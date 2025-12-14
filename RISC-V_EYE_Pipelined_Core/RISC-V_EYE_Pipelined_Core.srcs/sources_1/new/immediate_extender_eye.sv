`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: immediate_extender_eye.sv
// Module: Immediate Extender 
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////


module immediate_extender_eye(
    input  logic [31:7] instruction_in,
    input  logic [2:0]  op_select_in,
    output logic [31:0] imm_extended_out
    );

    always_comb begin
        case(op_select_in)
            // I-Type (ADDI, LW, JALR vb.)
            3'b000: imm_extended_out = {{20{instruction_in[31]}}, instruction_in[31:20]};

            // S-Type (SW vb.)
            3'b001: imm_extended_out = {{20{instruction_in[31]}}, instruction_in[31:25], instruction_in[11:7]};

            // B-Type (BEQ, BNE - Branch)
            3'b010: imm_extended_out = {{20{instruction_in[31]}}, instruction_in[7], instruction_in[30:25], instruction_in[11:8], 1'b0};

            // J-Type (JAL - Jump)
            3'b011: imm_extended_out = {{12{instruction_in[31]}}, instruction_in[19:12], instruction_in[20], instruction_in[30:21], 1'b0};

            // U-Type (LUI, AUIPC)
            3'b100: imm_extended_out = {instruction_in[31:12], 12'b0};

            default: imm_extended_out = 32'bx; 
        endcase
    end

endmodule
