`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 07:23:51 PM
// Design Name: 
// Module Name: Instr_Dec
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


module Instr_Dec(
    input [6:0] op,
    output reg [2:0] Imm_Src
    );

always @(*) begin
    case(op)
    7'b0110011: Imm_Src = 3'b000;
    7'b0010011: Imm_Src = 3'b000;
    7'b0000011: Imm_Src = 3'b000;
    7'b0100011: Imm_Src = 3'b001;
    7'b1100011: Imm_Src = 3'b010;
    7'b1101111: Imm_Src = 3'b011;
    7'b0010111: Imm_Src = 3'b100;
    7'b0110111: Imm_Src = 3'b100;
    7'b1100111: Imm_Src = 3'b000;
    default Imm_Src = 3'bx;
    endcase

end

endmodule
