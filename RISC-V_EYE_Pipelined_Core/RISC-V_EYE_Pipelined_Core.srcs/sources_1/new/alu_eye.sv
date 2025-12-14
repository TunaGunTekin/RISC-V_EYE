`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: alu_eye.sv
// Module: Arithmetic Logic Unit 32-bit 
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////

module alu_eye(
    input  logic [`DATA_WIDTH-1:0] src1_in,
    input  logic [`DATA_WIDTH-1:0] src2_in,
    input  logic [3:0]  alu_control_in,
    output reg   [`DATA_WIDTH-1:0] alu_result_out,
    output reg          zero_flag_out, c_flag_out, ov_flag_out, sign_flag_out
    );

    always_comb begin
        case (alu_control_in)
           4'b0000: begin // ADD & ADDI
			{c_flag_out, alu_result_out} = {1'b0, src1_in} + {1'b0, src2_in};
			end
		4'b0001: begin // SUB 
			{c_flag_out, alu_result_out} = {1'b0, src1_in} + {1'b0, ~src2_in} + 9'b1;
 			end
		4'b0010: begin // AND & ANDI
			alu_result_out = src1_in & src2_in;
			c_flag_out = 0;
			end
		4'b0011: begin // OR & ORI
			alu_result_out = src1_in | src2_in;
			c_flag_out = 0;
			end
		4'b0100: begin // SRA & SRAI
			alu_result_out = $signed(src1_in) >>> $unsigned(src2_in[4:0]);
			c_flag_out = 0;			
			end
		4'b0101: begin // SLT & SLTI
			if ($signed(src1_in) < $signed(src2_in))
				alu_result_out = 1;
			else
				alu_result_out = 0;
			    c_flag_out = 0;				
			end
		4'b0110: begin // SRL & SRLI
			alu_result_out = src1_in >> src2_in[4:0];
			c_flag_out = 0;			
			end
		4'b0111: begin // SLL & SLLI
			alu_result_out = src1_in << src2_in[4:0];
			c_flag_out = 0;			
			end
		4'b1000: begin // SLTU & SLTIU
			if($unsigned(src1_in) < $unsigned(src2_in))
			alu_result_out = 1;
			else
			alu_result_out = 0;
			c_flag_out = 0;				
			end
		4'b1001: begin // XOR & XORI
			alu_result_out = src1_in ^ src2_in;
			c_flag_out = 0;			
		end
		default: begin
			alu_result_out = 0;
			c_flag_out = 0;			
			end 
		endcase
		if (alu_result_out==0)
			zero_flag_out = 1;
		else
			zero_flag_out = 0;
		    sign_flag_out = alu_result_out[31];
		    ov_flag_out = (~((src1_in[31] ^ src2_in[31]) ^ alu_control_in[0])) & (src1_in[31] ^ sign_flag_out) & ~alu_control_in[1]; 
	end
endmodule
