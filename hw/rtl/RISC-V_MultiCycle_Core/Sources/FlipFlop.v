`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 03:08:59 PM
// Design Name: 
// Module Name: FlipFlop_En
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


module FlipFlop #(
    parameter WIDTH = 32
    )
    (
    input clk,reset,
    input [WIDTH-1:0] D,
    output reg [WIDTH-1:0] Q
    );
    
    
always @(posedge clk, posedge reset) begin
    if (reset) 
        Q <= {WIDTH{1'b0}};
    else 
        Q <= D;
end



endmodule