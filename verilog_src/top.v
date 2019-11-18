`include "const.vh"

 module top
 (
 	input start,
 	input rst_n,
 	input clk,
 	input rx,
 	output tx,
 	output [9 : 0] debug
);

parameter SIZE = `DEFAULT_SIZE, N = `DEFAULT_N;

wire [N * SIZE - 1 : 0] data;
wire [N * N * SIZE -1 : 0] weights;
wire rx_done;
wire comp_done;
wire [SIZE * N - 1 : 0] comp_data;
wire tx_done;
wire tx_act;


reg next = 0;


assign debug[7:0] = !start ? data[7:0] : comp_data[7:0];
assign debug[8] = !start ? rx_done : comp_done;

uart_rx_top #(.SIZE(SIZE), .N(N)) RX
(
	.clk(clk),
	.rst_n(rst_n),
	.rx(rx),
	.data(data),
	.done(rx_done)
);

w_reg #(.SIZE(SIZE), .N(N)) wreg
(
    .rd(weights)
);

net #(.SIZE(SIZE), .N(N)) hnet
(
    .en(next),
	.clk(clk),
    .rst_n(rst_n),
    .S(data[N * SIZE - 1 : 0]),
    .W(weights),
	.fullres(comp_data),
    .done(comp_done)
);


uart_tx_top #(.SIZE(SIZE), .N(N)) TX
(
	.clk(clk),
	.rst_n(rst_n),
	.data(comp_data),
	.en(comp_done),
	.tx(tx),
	.done(tx_done)
);


reg [1:0] count = 2'b01;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		next = 0;
		count = 2'b01;
	end
	else
	begin
		if(rx_done)
		begin
			count = count << 1;
			if(count === 2'b0)
			begin
				next = 1'b1;
			end
		end
		else
		begin
			if(tx_done)
			begin
				next = 1'b0;
			end
		end
	end	
end


endmodule
