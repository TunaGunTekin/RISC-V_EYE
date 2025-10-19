`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 07:10:50 PM
// Design Name: 
// Module Name: Alu_Dec
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


module Alu_Dec(
    input [1:0] Alu_Op,
    input Op5, Funct7b5,
    input [2:0] Funct3,
    output reg [3:0] Alu_Control
    );
    
always @(*) begin
    case(Alu_Op)
    2'b00: Alu_Control = 4'b0000;
    2'b01: Alu_Control = 4'b0001;
    2'b10: case (Funct3)
        3'b000: if({Op5, Funct7b5} == 2'b11)
                    Alu_Control = 4'b0001;
                else
                    Alu_Control = 4'b0000;
        3'b001: Alu_Control = 4'b0111; //Shift Left Logical
        3'b010: Alu_Control = 4'b0101; 
        3'b011: Alu_Control = 4'b1000; //Set Less Than Unsigned
        3'b100: Alu_Control = 4'b1001; //XOR
        3'b101: if(Funct7b5)
                    Alu_Control = 4'b0100; //Shift Right Arithmetic
                else
                    Alu_Control = 4'b0110; //Shift Right Logical
        3'b110: Alu_Control = 4'b0011;
        3'b111: Alu_Control = 4'b0010;
        default: Alu_Control = 4'bx;
        endcase
    default: Alu_Control = 4'bx;
    endcase
    
end

endmodule
