`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 04:53:09 PM
// Design Name: 
// Module Name: ALU
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


module ALU (
    input [31:0] Src1, Src2, 
    input [3:0] Alu_Control, 
    output reg [31:0] Out, 
    output reg Zero,
	output reg Cout, Overflow, Sign);
	
	always @(*) begin
		case (Alu_Control)
		4'b0000: begin // Summation
			{Cout, Out} = {1'b0, Src1} + {1'b0, Src2};
			end
		4'b0001: begin // Subtraction
			{Cout, Out} = {1'b0, Src1} + {1'b0, ~Src2} + 9'b1;
 			end
		4'b0010: begin // AND
			Out = Src1 & Src2;
			Cout = 0;
			end
		4'b0011: begin // OR
			Out = Src1 | Src2;
			Cout = 0;
			end
		4'b0100: begin // Shift Right Arithmetic
			Out = $signed(Src1) >>> $unsigned(Src2[4:0]);
			Cout = 0;			
			end
		4'b0101: begin // Greater Than Signed
			if ($signed(Src1) < $signed(Src2))
				Out = 1;
			else
				Out = 0;
			Cout = 0;				
			end
		4'b0110: begin // Shift Right Logical
			Out = Src1 >> Src2[4:0];
			Cout = 0;			
			end
		4'b0111: begin // Shift Left Logical
			Out = Src1 << Src2[4:0];
			Cout = 0;			
			end
		4'b1000: begin // Set Less Than Unsigned
			if($unsigned(Src1) < $unsigned(Src2))
			Out = 1;
			else
			Out = 0;
			Cout = 0;				
			end
		4'b1001: begin // XOR
			Out = Src1 ^ Src2;
			Cout = 0;			
		end
		default: begin
			Out = 0;
			Cout = 0;			
			end 
		endcase
		if (Out==0)
			Zero = 1;
		else
			Zero = 0;
		Sign = Out[31];
		Overflow = (~((Src1[31] ^ Src2[31]) ^ Alu_Control[0])) & (Src1[31] ^ Sign) & ~Alu_Control[1]; 
	end

endmodule 
