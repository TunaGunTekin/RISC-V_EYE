

`timescale 1ns / 1ps
`include "parameters.vh"

module bram_eye #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10 // 1024 satır (4KB bellek) - Test için yeterli
)(
    input logic clk,

    // --- PORT A: Instruction Fetch (Read Only) ---
    input logic [ADDR_WIDTH-1:0]  addr_a_in,
    output logic [DATA_WIDTH-1:0] read_data_a_out,

    // --- PORT B: Data Memory (Read / Write) ---
    input logic                   we_b_in,         // Write Enable
    input logic [ADDR_WIDTH-1:0]  addr_b_in,
    input logic [DATA_WIDTH-1:0]  write_data_b_in,
    output logic [DATA_WIDTH-1:0] read_data_b_out
);

    // Bellek Dizisi
    // Vivado bu tanımlamayı görünce otomatik BRAM oluşturur.
    (* ram_style = "block" *) 
    logic [DATA_WIDTH-1:0] ram [0:(2**ADDR_WIDTH)-1];

    // Opsiyonel: Belleği başlangıçta bir dosya ile doldurmak için
    initial begin
       // 1. ADDI x1, x0, 5    (x1 = 5)
        ram[0] = 32'h00500093;

        // 2. ADDI x2, x0, 3    (x2 = 3)
        ram[1] = 32'h00300113;

        // 3. ADD x3, x1, x2    (x3 = x1 + x2 = 8)
        ram[2] = 32'h002081B3;

        // 4. SUB x4, x1, x2    (x4 = x1 - x2 = 2)
        ram[3] = 32'h40208233;

        // 5. OR x5, x1, x2     (x5 = x1 | x2 = 7)
        ram[4] = 32'h0020E2B3;

        // 6. AND x6, x1, x2    (x6 = x1 & x2 = 1)
        ram[5] = 32'h0020F333;

        // 7. SLLI x7, x1, 2    (x7 = x1 << 2 = 20)
        ram[6] = 32'h00209393;

        // 8. BEQ x0, x0, 0     (Sonsuz Döngü - Olduğu yerde sayar)
        // Offset 0 olduğu için sürekli aynı satırı (PC=28) tekrar fetch eder.
        ram[7] = 32'h00000063;

        // Belleğin geri kalanı boş kalsın (veya NOP)
    end

    // Port A Operasyonu (Instruction)
    always_ff @(posedge clk) begin
        read_data_a_out <= ram[addr_a_in];
    end

    // Port B Operasyonu (Data)
    always_ff @(posedge clk) begin
        if (we_b_in) begin
            ram[addr_b_in] <= write_data_b_in;
        end
        read_data_b_out <= ram[addr_b_in];
    end

endmodule