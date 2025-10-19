`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 06:48:32 PM
// Design Name: 
// Module Name: FSM
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


module FSM(
    input clk,reset,
    input [6:0] op,
    output reg Branch, PC_Update, Reg_Write, Mem_Write, Ir_Write,
    output reg [1:0] Result_Src, Alu_SrcA, Alu_SrcB,
    output reg Adr_Src,
    output reg [1:0] Alu_Op
    );
    
parameter [3:0] s0  = 4'd0,
                 s1  = 4'd1,
                 s2  = 4'd2,
                 s3  = 4'd3,
                 s4  = 4'd4,
                 s5  = 4'd5,
                 s6  = 4'd6,
                 s7  = 4'd7,
                 s8  = 4'd8,
                 s9  = 4'd9,
                 s10 = 4'd10,
                 s11 = 4'd11,
                 s12 = 4'd12,
                 s13 = 4'd13;

reg [3:0] state, nextstate;

always @(posedge clk,posedge reset) begin
    if(reset)
        state <= s0;
    else 
        state <= nextstate;
end

always @(*) begin
    case(state)
        s0 : nextstate <= s1;
        s1 : case(op)
            7'b0110011: nextstate = s6;
            7'b0010011: nextstate = s8;
            7'b0000011: nextstate = s2;
            7'b0100011: nextstate = s2;
            7'b1100011: nextstate = s10;
            7'b1101111: nextstate = s9;
            7'b0010111: nextstate = s11;
            7'b0110111: nextstate = s12;
            7'b1100111: nextstate = s2;
            default:    nextstate = s13;
        endcase
        s2 : if(op[5]) begin
                if(op[6]) 
                    nextstate <= s9;
                else 
                    nextstate <= s5;
             end
             else 
                nextstate <= s3;
         s3:  nextstate <= s4;
         s4:  nextstate <= s0;
         s5:  nextstate <= s0;
         s6:  nextstate <= s7;
         s7:  nextstate <= s0;
         s8:  nextstate <= s7;
         s9:  nextstate <= s7;
         s10: nextstate <= s0;
         s11: nextstate <= s7;
         s12: nextstate <= s0;
         s13: nextstate <= s13;
     endcase
 end
     
always @(*) begin
        Branch    = 1'b0;
        PC_Update  = 1'b0;
        Reg_Write  = 1'b0;
        Mem_Write  = 1'b0;
        Ir_Write   = 1'b0;
        Adr_Src    = 1'b0;
        Result_Src = 2'b00;
        Alu_SrcB   = 2'b00;
        Alu_SrcA   = 2'b00;
        Alu_Op     = 2'b00;

        case (state)
            s0: begin
                PC_Update  = 1'b1;
                Ir_Write   = 1'b1;
                Result_Src = 2'b10;
                Alu_SrcB   = 2'b10;
                Alu_SrcA   = 2'b00;
                Adr_Src    = 1'b0;
            end
            s1: begin
                Alu_SrcB = 2'b01;
                Alu_SrcA = 2'b01;
            end
            s2: begin
                Alu_SrcB = 2'b01;
                Alu_SrcA = 2'b10;
            end
            s3: begin
                Adr_Src = 1'b1;
            end
            s4: begin
                Reg_Write  = 1'b1;
                Result_Src = 2'b01;
            end
            s5: begin
                Mem_Write = 1'b1;
                Adr_Src   = 1'b1;
            end
            s6: begin
                Alu_SrcA = 2'b10;
                Alu_Op   = 2'b10;
            end
            s7: begin
                Reg_Write = 1'b1;
            end
            s8: begin
                Alu_SrcB = 2'b01;
                Alu_SrcA = 2'b10;
                Alu_Op   = 2'b10;
            end
            s9: begin
                PC_Update = 1'b1;
                Alu_SrcB  = 2'b10;
                Alu_SrcA  = 2'b01;
            end
            s10: begin
                Branch  = 1'b1;
                Alu_SrcA = 2'b10;
                Alu_Op   = 2'b01;
            end
            s11: begin
                Alu_SrcB = 2'b01;
                Alu_SrcA = 2'b01;
            end
            s12: begin
                Reg_Write  = 1'b1;
                Result_Src = 2'b11;
            end
            s13: begin
                Branch    = 1'bx;
                PC_Update  = 1'bx;
                Reg_Write  = 1'bx;
                Mem_Write  = 1'bx;
                Ir_Write   = 1'bx;
                Result_Src = 2'bx;
                Alu_SrcB   = 2'bx;
                Alu_SrcA   = 2'bx;
                Adr_Src    = 1'bx;
                Alu_Op     = 2'bx;
            end
        endcase
    end
endmodule