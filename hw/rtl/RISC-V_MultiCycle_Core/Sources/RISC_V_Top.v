`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 08:16:49 PM
// Design Name: 
// Module Name: RISC_V_Top
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


module RISC_V_Top(
    input clk,reset,
    output [31:0] Write_Data,Data_Adr,
    output Mem_Write
    );
    
wire [31:0] Read_Data;

RISC_V_MultiCycle RISC_V_Core_Inst(
    .clk(clk),
    .reset(reset),
    .Read_Data(Read_Data),
    .Address(Data_Adr),
    .Mem_Write(Mem_Write),
    .Write_Data(Write_Data)
    );

Memory Memory_Inst(
    .clk(clk),
    .Write_En(Mem_Write),
    .Addr(Data_Adr),
    .Write_Data(Write_Data),
    .Read_Data(Read_Data)
    );
    

endmodule
