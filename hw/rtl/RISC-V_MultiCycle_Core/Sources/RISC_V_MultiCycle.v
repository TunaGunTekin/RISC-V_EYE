`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 07:57:45 PM
// Design Name: 
// Module Name: RISC_V_MultiCycle
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


module RISC_V_MultiCycle(
    input clk,reset,
    input [31:0] Read_Data,
    output  [31:0] Address,
    output  Mem_Write,
    output  [31:0] Write_Data
    );
wire [2:0] Imm_Src;    
wire [1:0] Result_Src, Alu_SrcA,Alu_SrcB;
wire Adr_Src, Zero,Cout,Overflow,Sign;
wire [3:0] Alu_Control;
wire Ir_Write, PC_Write;
wire Reg_Write;
wire [31:0] Instr;

Control_Unit Control_Unit_Inst(
    .clk(clk),
    .reset(reset),
    .op(Instr[6:0]),
    .Funct3(Instr[14:12]),
    .Funct7b5(Instr[30]),
    .Zero(Zero),
    .Cout(Cout),
    .Overflow(Overflow),
    .Sign(Sign),
    .Imm_Src(Imm_Src),
    .Alu_SrcA(Alu_SrcA),
    .Alu_SrcB(Alu_SrcB),
    .Result_Src(Result_Src),
    .Adr_Src(Adr_Src),
    .Alu_Control(Alu_Control),
    .Ir_Write(Ir_Write),
    .PC_Write(PC_Write),
    .Reg_Write(Reg_Write),
    .Mem_Write(Mem_Write)
    );
    
Data_Path Data_Path_Inst(
    .clk(clk),
    .reset(reset),
    .Imm_Src(Imm_Src),
    .Alu_Control(Alu_Control),
    .Result_Src(Result_Src),
    .IR_Write(Ir_Write),
    .Reg_Write(Reg_Write),
    .ALU_Src_A(Alu_SrcA),
    .ALU_Src_B(Alu_SrcB),
    .Adr_Src(Adr_Src),
    .PC_Write(PC_Write),
    .Read_Data(Read_Data),
    .Zero(Zero),
    .Cout(Cout),
    .Overflow(Overflow),
    .Sign(Sign),
    .Adr(Address),
    .Write_Data(Write_Data),
    .Instr(Instr)
    );
    

endmodule
