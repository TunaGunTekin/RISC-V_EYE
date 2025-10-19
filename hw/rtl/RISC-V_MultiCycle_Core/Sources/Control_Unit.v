`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 07:35:42 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
    input  clk,
	input  reset,
	input  [6:0] op,
	input  [2:0] Funct3,
	input  Funct7b5,
	input  Zero, Cout, Overflow, Sign,
	output  [2:0] Imm_Src,
	output  [1:0] Alu_SrcA, Alu_SrcB,
	output  [1:0] Result_Src,
	output  Adr_Src,
	output  [3:0] Alu_Control,
	output  Ir_Write, PC_Write,
	output  Reg_Write, Mem_Write
    );
wire  Branch, PC_Update;
wire beq, bne, blt, bge, bltu, bgeu;
wire [1:0] Alu_Op;

FSM FSM_Main(
    .clk(clk),
    .reset(reset),
    .op(op),
    .Branch(Branch),
    .PC_Update(PC_Update),
    .Reg_Write(Reg_Write),
    .Mem_Write(Mem_Write),
    .Ir_Write(Ir_Write),
    .Result_Src(Result_Src),
    .Alu_SrcA(Alu_SrcA),
    .Alu_SrcB(Alu_SrcB),
    .Adr_Src(Adr_Src),
    .Alu_Op(Alu_Op)
    );
    
Alu_Dec Alu_Dec_Inst(
    .Alu_Op(Alu_Op),
    .Op5(op[5]),
    .Funct7b5(Funct7b5),
    .Funct3(Funct3),
    .Alu_Control(Alu_Control)
    );
  
Instr_Dec Instr_Dec_Inst(
    .op(op),
    .Imm_Src(Imm_Src)
    );

Branch_Dec Branch_Dec_Inst(
    .op(op),
    .funct3(Funct3),
    .branch(Branch),
    .beq(beq),
    .bne(bne),
    .blt(blt),
    .bge(bge),
    .bltu(bltu),
    .bgeu(bgeu)
    );
    
assign PC_Write = (beq & Zero) | (bne & ~Zero) | (bgeu & Cout) | (bltu & ~Cout) | (bge & (Sign == Overflow)) | (blt & (Sign != Overflow)) | PC_Update;

endmodule
