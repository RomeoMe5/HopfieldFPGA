// Чтение весов сети из HEX-файла

module w_reg
(
    output [N * N * SIZE - 1 : 0] rd
);
    parameter SIZE = 32;
    parameter N = 4;

    reg [SIZE * N * N - 1 : 0] rom [0:0];
    assign rd = rom[0];

    initial 
    begin
        $readmemh ("weights.hex", rom);
    end
endmodule

