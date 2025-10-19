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


module FlipFlop_En #(
    parameter WIDTH = 8
    )
    (
    input clk,reset,en,
    input [WIDTH-1:0] D,
    output reg [WIDTH-1:0] Q
    );
    
    
always @(posedge clk, posedge reset) begin
    if (reset) 
        Q <= {WIDTH{1'b0}};
    else if (en)
        Q <= D;
end


endmodule
