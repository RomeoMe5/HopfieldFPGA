`include "const.vh"

module uart_rx_top
(
	input clk,
	input rst_n,
	input rx,
	output [N * SIZE - 1 : 0] data,
	output done
);

parameter N = 9;
parameter SIZE = 32;

wire onedone;
wire [7:0] onedata;

reg [N * SIZE - 1 : 0] dataReg = {N * SIZE {1'b0}};
reg doneReg = 0;
reg [N - 1 : 0] counter = {{N - 1 {1'b0}}, 1'b1};


assign data = dataReg;
assign done = doneReg;


uart_rx #(.CLKS_PER_BIT(`DEFAULT_CLKS_PER_BIT)) onebyte
(
   .i_Clock(clk),
   .i_Rx_Serial(rx),
   .o_Rx_DV(onedone),
   .o_Rx_Byte(onedata)
);


always @(posedge onedone or negedge rst_n)
begin
	if(!rst_n)
	begin
		counter <= {{N - 1 {1'b0}}, 1'b1};
		dataReg <= {N * SIZE {1'b0}};
		doneReg <= 0;
	end
	else
	begin
		dataReg [SIZE-1:0] = {{SIZE-8{onedata[7]}},onedata[7:0]};
		counter = counter << 1;

		if(counter === {N{1'b0}})
		begin
			doneReg = 1;
		
		end
		else
			dataReg = dataReg << SIZE;
		
	end
end

endmodule
