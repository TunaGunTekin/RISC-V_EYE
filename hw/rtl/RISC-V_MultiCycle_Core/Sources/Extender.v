`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// 
// Design Name: 
// Module Name: Extender
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


module Extender(
    input [31:7] Instr, 
    input [2:0] Imm_Src,
    output reg [31:0] Imm_Ext
    );
    
    
always @(*)
    case(Imm_Src)
        // I-Type Instruction
        3'b000: Imm_Ext = {{20{Instr[31]}},Instr[31:20]};
        // S-Type Instruction
		3'b001: Imm_Ext = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
		// B-Type Instruction
		3'b010: Imm_Ext = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
		// J-Type Instruction
		3'b011: Imm_Ext = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
		// U-Type InstructionU
		3'b100: Imm_Ext = {Instr[31:12], 12'b0};
		// undefined ? 
		default: Imm_Ext = 32'bx; 
		
	endcase
endmodule
