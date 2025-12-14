`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: control_unit_eye.sv
// Module: Control Unit 
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////


module control_unit_eye(
    input  logic [6:0] opcode_in,
    input  logic [2:0] funct3_in,
    input  logic       funct7b5_in,

    output logic  [2:0] imm_extend_op_select_decode_out,
    output logic        alu_src_select_decode_out,
    output logic  [3:0] alu_op_select_decode_out,

    output logic        mem_read_enable_decode_out,
    output logic        mem_write_enable_decode_out,
    output logic  [1:0] mem_to_reg_select_decode_out,
    output logic        reg_write_enable_decode_out
    );

    always_comb begin
        case (opcode_in)
            `OP_LUI : begin
                assign imm_extend_op_select_decode_out = 3'b100; // U-Type
                assign alu_src_select_decode_out = 1'b1; // Immediate
                assign alu_op_select_decode_out = 4'b0000; // ADD operation for LUI
                // Control signals for LUI        
            end
            `OP_AUIPC : begin
                assign imm_extend_op_select_decode_out = 3'b100; // U-Type
                assign alu_src_select_decode_out = 1'b1; // Immediate
                assign alu_op_select_decode_out = 4'b0000; // ADD operation for AUIPC
                // Control signals for AUIPC
            end
            `OP_JAL : begin
                // Control signals for JAL
            end
            `OP_JALR : begin
                case (funct3_in)
                    `BRANCH_JAL_JALR: begin
                        // Control signals for JALR
                    end
                    default: begin
                        // Default case
                    end
                endcase
            end
            `OP_BRANCH: begin
                case (funct3_in)
                    `BRANCH_BEQ: begin
                        // Control signals for BEQ
                    end
                    `BRANCH_BNE: begin
                        // Control signals for BNE
                    end
                    `BRANCH_BLT: begin
                        // Control signals for BLT
                    end
                    `BRANCH_BGE: begin
                        // Control signals for BGE
                    end
                    `BRANCH_BLTU: begin
                        // Control signals for BLTU
                    end
                    `BRANCH_BGEU: begin
                        // Control signals for BGEU
                    end
                    default: begin
                        // Default case
                    end
                endcase
            end
            
            `OP_LOAD: begin
                case (funct3_in)
                    `LOAD_LB: begin
                        // Control signals for LB
                    end
                    `LOAD_LH: begin
                        // Control signals for LH
                    end
                    `LOAD_LW: begin
                        // Control signals for LW
                    end
                    `LOAD_LBU: begin
                        // Control signals for LBU
                    end
                    `LOAD_LHU: begin
                        // Control signals for LHU
                    end
                    default: begin
                        // Default case
                    end
                endcase
            end
            `OP_STORE: begin
                case (funct3_in)
                    `STORE_SB: begin
                        // Control signals for SB
                    end
                    `STORE_SH: begin
                        // Control signals for SH
                    end
                    `STORE_SW: begin
                        // Control signals for SW
                    end
                    default: begin
                        // Default case
                    end
                endcase
            end

            // Add other opcode cases here (LOAD, STORE, BRANCH, etc.)
            `OP_ALU: begin
                case ({funct7b5_in, funct3_in})
                    `ALU_ADD: begin
                        assign alu_op_select_decode_out = 4'b0000; // ADD
                        // Control signals for ADD
                    end
                    `ALU_SUB: begin
                        assign alu_op_select_decode_out = 4'b0001; // SUB
                        // Control signals for SUB
                    end
                    `ALU_AND: begin
                        assign alu_op_select_decode_out = 4'b0010; // AND
                        // Control signals for AND
                    end
                    `ALU_OR: begin
                        assign alu_op_select_decode_out = 4'b0011; // OR
                        // Control signals for OR
                    end
                    `ALU_XOR: begin
                        assign alu_op_select_decode_out = 4'b1001; // XOR
                        // Control signals for XOR
                    end
                    `ALU_SLT: begin
                        assign alu_op_select_decode_out = 4'b0101; // SLT
                        // Control signals for SLT
                    end
                    `ALU_SLTU: begin  
                        assign alu_op_select_decode_out = 4'b1000; // SLTU  
                        // Control signals for SLTU 
                    end 
                    `ALU_SLL: begin
                        assign alu_op_select_decode_out = 4'b0111; // SLL
                        // Control signals for SLL
                    end
                    `ALU_SRL: begin
                        assign alu_op_select_decode_out = 4'b0110; // SRL
                        // Control signals for SRL
                    end
                    `ALU_SRA: begin
                        assign alu_op_select_decode_out = 4'b0100; // SRA
                    end
                    default: begin
                        // Default case
                    end
                endcase
            end
            `OP_ALUI: begin
                case (funct3_in)
                    `ALU_ADDI: begin
                        assign alu_op_select_decode_out = 4'b0000; // ADDI
                        // Control signals for ADDI
                    end
                    `ALU_ANDI: begin
                        assign alu_op_select_decode_out = 4'b0010; // ANDI
                        // Control signals for ANDI
                    end
                    `ALU_ORI: begin
                        assign alu_op_select_decode_out = 4'b0011; // ORI
                        // Control signals for ORI
                    end
                    `ALU_XORI: begin
                        assign alu_op_select_decode_out = 4'b1001; // XORI
                        // Control signals for XORI
                    end
                    `ALU_SLTI: begin
                        assign alu_op_select_decode_out = 4'b0101; // SLTI
                        // Control signals for SLTI
                    end
                    `ALU_SLTIU: begin
                        assign alu_op_select_decode_out = 4'b1000; // SLTIU
                        // Control signals for SLTIU
                    end
                    `ALU_SLLI: begin
                        assign alu_op_select_decode_out = 4'b0111; // SLLI
                        // Control signals for SLLI
                    end
                    `ALU_SRLI: begin
                        assign alu_op_select_decode_out = 4'b0110; // SRLI
                        // Control signals for SRLI
                    end
                    `ALU_SRAI: begin
                        assign alu_op_select_decode_out = 4'b0100; // SRAI
                        // Control signals for SRAI
                    end
                    default: begin
                        // Default case
                    end
                endcase
            end
            `OP_FENCE: begin
                // Control signals for FENCE
            end
            `OP_SYSTEM: begin
                // Control signals for SYSTEM
            end
            default: begin
                // Default case for unknown opcode
            end
        endcase
    end



endmodule
