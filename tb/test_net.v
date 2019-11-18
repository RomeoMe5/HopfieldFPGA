`timescale 1 ns / 100 ps
module test_net;
    parameter N = 81;
    parameter SIZE = 16; 

    integer i;

    reg clk, rst_n, en;

    wire [N * SIZE - 1 : 0] S;
    wire [SIZE * N * N - 1 : 0] W;
    wire [N * SIZE - 1 : 0] res;
    wire complite;

    w_reg #(.N(N), .SIZE(SIZE)) WReg(W);
    s_reg #(.N(N), .SIZE(SIZE)) SReg(S);

    net #(.N(N), .SIZE(SIZE)) hopf
    (
        .en(en),
        .clk(clk),
        .rst_n(rst_n),
        .S(S),
        .W(W),
        .fullres(res),
        .done(complite)
    );

    initial 
    begin
        clk = 0;
        forever clk = #(10) ~clk;
    end

    initial
    begin
        en = 0;
        rst_n = 1;
        #(70) en = 1;
    end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0, test_net);
end

initial
begin
    #4000 $finish;
end

endmodule