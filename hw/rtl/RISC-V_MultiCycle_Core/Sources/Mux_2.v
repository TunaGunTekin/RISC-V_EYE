`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 04:02:13 PM
// Design Name: 
// Module Name: Mux_2
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


module Mux_2 #(
    parameter WIDTH = 8
    )
	(
	input [WIDTH-1:0] In0, In1, 
	input Select, 
	output [WIDTH-1:0] Out
	);

	assign Out = Select ? In1 : In0; 

endmodule