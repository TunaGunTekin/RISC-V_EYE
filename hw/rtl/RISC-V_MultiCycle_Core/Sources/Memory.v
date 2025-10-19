`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 08:23:14 PM
// Design Name: 
// Module Name: Memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Memory(
    input clk,Write_En,
    input [31:0] Addr, Write_Data,
    output [31:0] Read_Data
    );
    
reg [31:0] RAM [63:0];

initial 
    $readmemh("/home/tuna-gun/Downloads/RISCV-multi-cycle-processor-main/finaltest.txt",RAM);
    
assign Read_Data = RAM[Addr[31:2]];

always @(posedge clk)
    if (Write_En) RAM[Addr[31:2]] <= Write_Data;
endmodule
