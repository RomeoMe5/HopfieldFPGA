`include "const.vh"

module uart_tx_top
(
	input clk,
	input rst_n,
	input [N * SIZE - 1 : 0] data,
	input en,
	output tx,
	output done
);

	parameter N = 9;
	parameter SIZE = 32;
	
	reg [N * SIZE - 1 : 0] currdata;
	reg [N : 0] counter = 'd1;
	reg en_tx = 1'b0;
	reg [N : 0] nextcounter = 'd2;
	
	wire tx_act, tx_done;
	
	uart_tx #(.CLKS_PER_BIT(`DEFAULT_CLKS_PER_BIT)) TX 
	(
	   .i_Clock(clk),
	   .i_Tx_DV(en_tx),
	   .i_Tx_Byte(currdata[7:0]), 
	   .o_Tx_Active(tx_act),
	   .o_Tx_Serial(tx),
	   .o_Tx_Done(tx_done)
	);

	
	always @(negedge clk or negedge rst_n)
	begin
		if(!rst_n)
		begin
			currdata <= 'b0;
			counter <= 'd1;
			en_tx <= 1'b0;
			nextcounter <= 'd2;
		end
		else
		begin
			if(tx_done)
			begin
				
				if(nextcounter === counter)
				begin
					currdata <= currdata >> SIZE;
					nextcounter <= nextcounter << 1;
				end
				
				if(counter ===  'd0)
				begin
					en_tx <= 1'b0;
				end
			end
			else if(tx_act)
			begin
				counter <= nextcounter;
			end
			else if(en && counter === 'd1)
			begin
				en_tx <= 1'b1;
				currdata <= data;
			end


		end
	end



endmodule

