// Чтение входных данных из файла

module s_reg
(
    output [N * SIZE - 1 : 0] rd
);
    parameter SIZE = 32;
    parameter N = 4;

    reg [SIZE * N - 1 : 0] rom [0:0];
    assign rd = rom[0];

    initial 
    begin
        $readmemh ("../data/testbench_input.hex", rom);
    end

endmodule

