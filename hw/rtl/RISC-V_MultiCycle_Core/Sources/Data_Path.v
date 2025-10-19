`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 04:12:20 PM
// Design Name: 
// Module Name: Data_Path
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


module Data_Path(
    input clk, reset,
	input [2:0] Imm_Src, 
	input [3:0] Alu_Control, 
	input [1:0] Result_Src, 
	input IR_Write,
	input Reg_Write,
	input [1:0] ALU_Src_A, ALU_Src_B, 
	input Adr_Src, 
	input PC_Write,  
	input [31:0] Read_Data,
	output  Zero, Cout, Overflow, Sign, 
	output [31:0] Adr, 
	output  [31:0] Write_Data,
	output [31:0] Instr
    );
    
wire [31:0] Result;
wire[31:0] ALU_Out;
wire[31:0] ALU_Result;
wire [31:0] RD1, RD2;
wire[31:0] A;
wire [31:0] SrcA, SrcB;
wire [31:0] Data;
wire[31:0] Imm_Ext;
wire[31:0] PC, Old_PC;

// Program Counter
FlipFlop_En #(
    32
    ) PC_Inst (
    .clk(clk),
    .reset(reset),
    .en(PC_Write),
    .D(Result),
    .Q(PC)
);

// Register File and Immediate Extender
Reg_File Reg_File_Inst (
    .clk(clk),
    .Write_En(Reg_Write),
    .Adr1(Instr[19:15]),
    .Adr2(Instr[24:20]),
    .Adr3(Instr[11:7]),
    .Write_Data(Result),
    .Read1(RD1),
    .Read2(RD2)
);

Extender Extender_Inst (
    .Instr(Instr[31:7]),
    .Imm_Src(Imm_Src),
    .Imm_Ext(Imm_Ext)
);

FlipFlop #(32) reg_File1(
    .clk(clk),
    .reset(reset),
    .D(RD1),
    .Q(A)
);

FlipFlop #(32) reg_File2(
    .clk(clk),
    .reset(reset),
    .D(RD2),
    .Q(Write_Data)
);

// ALU Logic 
Mux_3 #(32) Src_A_Mux(
    .In0(PC),
    .In1(Old_PC),
    .In2(A),
    .Select(ALU_Src_A),
    .Out(SrcA)
);

Mux_3 #(32) Src_B_Mux (
    .In0(Write_Data),
    .In1(Imm_Ext),
    .In2(32'd4),
    .Select(ALU_Src_B),
    .Out(SrcB)
);

ALU ALU_Inst ( 
    .Src1(SrcA),
    .Src2(SrcB),
    .Alu_Control(Alu_Control),
    .Out(ALU_Result),
    .Zero(Zero),
    .Cout(Cout),
    .Overflow(Overflow),
    .Sign(Sign)
);

FlipFlop #(32) ALU_Reg (
    .clk(clk),
    .reset(reset),
    .D(ALU_Result),
    .Q(ALU_Out)
);

Mux_4 #(32) Result_Mux (
    .In0(ALU_Out),
    .In1(Data),
    .In2(ALU_Result),
    .In3(Imm_Ext),
    .Select(Result_Src),
    .Out(Result)
);

// Memory Access Logic 
Mux_2 #(32) Adr_Mux (
    .In0(PC),
    .In1(Result),
    .Select(Adr_Src),
    .Out(Adr)
);

FlipFlop_En #(32) Mem_Flop1 (
    .clk(clk),
    .reset(reset),
    .en(IR_Write),
    .D(PC),
    .Q(Old_PC)
);

FlipFlop_En #(32) Mem_Flop2 (
    .clk(clk),
    .reset(reset),
    .en(IR_Write),
    .D(Read_Data),
    .Q(Instr)
);

FlipFlop #(32) Mem_DataFlop (
    .clk(clk),
    .reset(reset),
    .D(Read_Data),
    .Q(Data)
);

endmodule
