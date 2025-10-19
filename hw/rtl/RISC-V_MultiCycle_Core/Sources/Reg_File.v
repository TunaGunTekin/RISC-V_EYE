`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 03:52:12 PM
// Design Name: 
// Module Name: Reg_File
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


module Reg_File(
    input clk, Write_En,
    input [4:0] Adr1,Adr2,Adr3,
    input [31:0] Write_Data,
    output [31:0] Read1, Read2
    );
    
    reg [31:0] Reg_File [31:0];
    
    always @(posedge clk) begin
        if (Write_En && (Adr3 != 0))
            Reg_File[Adr3] = Write_Data;
    end 
        
    assign Read1 = Adr1==0 ? 0 : Reg_File[Adr1];
    assign Read2 = Adr2==0 ? 0 : Reg_File[Adr2];
            
endmodule
