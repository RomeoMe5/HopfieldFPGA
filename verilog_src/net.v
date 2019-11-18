module net
(
    input en,
    input clk,
    input rst_n,
    input [SIZE * N - 1 : 0] S,
    input [SIZE * N * N - 1 : 0] W,
	output [SIZE * N - 1 : 0] fullres,
    output done
);

    parameter N = 9;
    parameter SIZE = 32; 

    wire [N-1 : 0] allDone;
    wire [SIZE * N - 1 : 0] Snew;
    wire resDone;
    wire [SIZE * N - 1 : 0] Sres;

    reg first = 1'b1;
    reg doneReg = 1'b0;
    reg [SIZE * N - 1 : 0] SoldReg = 'd0;

    assign resDone = &allDone;
    assign done = doneReg;
    assign Snew = (first) ? S : Sres; // FIX
	assign fullres = Sres;
	
	
    genvar i;
    generate 
        for (i = 0; i < N; i = i + 1)
        begin : generate_block_identifier

            neuron #(.N(N), .SIZE(SIZE)) one
            (   
                .en(en),
                .clk(clk),
                .rst_n(rst_n),
                .Scurr(Snew),   
                .W(W [(N) * SIZE * (i + 1) - 1 : N * SIZE * i]),
                .Snext(Sres [SIZE * (N - i) - 1 : SIZE * (N - i - 1)]),
                .done(allDone[i])
            );
        end
    endgenerate

    always @(posedge resDone or negedge rst_n)
    begin
        if (!rst_n)
        begin 
            first <= 1'b1;
			doneReg <= 1'b0;
        end
        else
        begin
			first <= 1'b0;
            if(Sres === SoldReg)
                doneReg <= 1'b1;
            else
                SoldReg <= Sres;

        end
    end

endmodule
