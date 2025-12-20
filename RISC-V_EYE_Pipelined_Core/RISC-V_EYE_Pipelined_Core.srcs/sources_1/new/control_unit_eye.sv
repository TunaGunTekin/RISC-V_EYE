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
    input  logic  [6:0] opcode_in,
    input  logic  [2:0] funct3_in,
    input  logic        funct7b5_in,

    //Execute Stage Control Signals 
    output logic  [2:0] imm_extend_op_select_out,
    output logic        alu_src_a_select_out, // 0: Rs1, 1: PC (AUIPC/JAL)
    output logic        alu_src_b_select_out, // 0: Rs2, 1: Immediate
    output logic  [3:0] alu_op_select_out,
    output logic        is_jalr_out,

    //Memory Stage Control Signals
    output logic        mem_read_enable_out,
    output logic        mem_write_enable_out,
    output logic [1:0]       mem_to_reg_select_out,

    //Write Back Stage Control Signals
    output logic        reg_write_enable_out,
    output logic  [1:0] result_source_select_out,

    //Hazard Unit Signals
    output logic        branch_enable_out,
    output logic        jump_enable_out
    );

   /* always_comb begin
        // Default values for control signals it prevent latches 
        imm_extend_op_select_out = 3'b000;
        alu_src_a_select_out = 1'b0;
        alu_src_b_select_out = 1'b0;
        alu_op_select_out = 4'b0000;
        is_jalr_out = 1'b0;
        mem_read_enable_out = 1'b0;
        mem_write_enable_out = 1'b0;

        reg_write_enable_out = 1'b0;
        result_source_select_out = 2'b00;

        branch_enable_out = 1'b0;
        jump_enable_out = 1'b0;
    end */

    always_comb begin
        case (opcode_in)
            `OP_LUI : begin
                // LUI : Rd = Imm.  
                // LUI: Imm + 0 (Rs1=x0).
                imm_extend_op_select_out = 3'b100; // U-Type
                reg_write_enable_out = 1'b1;
                alu_src_a_select_out = 1'b1; // Rs1 is not used
                alu_src_b_select_out = 1'b1; // Immediate
                alu_op_select_out = 4'b0000; // ADD operation for LUI
                //CHECK AGAIN

                // Control signals for LUI        
            end
            `OP_AUIPC : begin
                imm_extend_op_select_out = 3'b100; // U-Type
                alu_src_a_select_out = 1'b1; // Rs1 = PC
                alu_src_b_select_out = 1'b1; // Immediate
                alu_op_select_out = 4'b0000; // ADD operation for AUIPC
                //CHECK AGAIN
                
                // Control signals for AUIPC
            end
            `OP_JAL : begin
                jump_enable_out = 1'b1;
                imm_extend_op_select_out = 3'b011; // J-Type
                reg_write_enable_out = 1'b1;
                // JAL için ALU'ya gerek yok ama hedef adresi Execute Stage PC+Imm ile hesaplar.
                // WB aşamasında PC+4 yazılır.
                result_source_select_out = 2'b10; // PC + 4
                //CHECK AGAIN
                
                // Observe "branch_target_calc" for this instruction.
                // Control signals for JAL
            end
            `OP_JALR : begin
                case (funct3_in)
                    `BRANCH_JAL_JALR: begin
                        is_jalr_out = 1'b1;
                        jump_enable_out = 1'b1;
                        imm_extend_op_select_out = 3'b000; // I-Type
                        alu_src_a_select_out = 1'b0; // Rs1
                        alu_src_b_select_out = 1'b1; // Immediate
                        alu_op_select_out = 4'b0000; // ADD operation for JALR
                        reg_write_enable_out = 1'b1;
                        result_source_select_out = 2'b10; // PC + 4
                        //CHECK AGAIN
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

            
            `OP_ALU: begin
                alu_src_a_select_out = 1'b0; // Rs1
                alu_src_b_select_out = 1'b0; // Rs2
                imm_extend_op_select_out = 3'b000; // I type
                case ({funct7b5_in, funct3_in})
                    `ALU_ADD: begin
                        alu_op_select_out = 4'b0000; // ADD
                        // Control signals for ADD
                    end
                    `ALU_SUB: begin
                        alu_op_select_out = 4'b0001; // SUB
                        // Control signals for SUB
                    end
                    `ALU_AND: begin
                        alu_op_select_out = 4'b0010; // AND
                        // Control signals for AND
                    end
                    `ALU_OR: begin
                        alu_op_select_out = 4'b0011; // OR
                        // Control signals for OR
                    end
                    `ALU_XOR: begin
                        alu_op_select_out = 4'b1001; // XOR
                        // Control signals for XOR
                    end
                    `ALU_SLT: begin
                        alu_op_select_out = 4'b0101; // SLT
                        // Control signals for SLT
                    end
                    `ALU_SLTU: begin  
                        alu_op_select_out = 4'b1000; // SLTU  
                        // Control signals for SLTU 
                    end 
                    `ALU_SLL: begin
                        alu_op_select_out = 4'b0111; // SLL
                        // Control signals for SLL
                    end
                    `ALU_SRL: begin
                        alu_op_select_out = 4'b0110; // SRL
                        // Control signals for SRL
                    end
                    `ALU_SRA: begin
                        alu_op_select_out = 4'b0100; // SRA
                    end
                    default: begin
                        // Default case
                    end
                endcase
            end
            `OP_ALUI: begin
                alu_src_a_select_out = 1'b0; // Rs1
                alu_src_b_select_out = 1'b1; // Immediate
                case (funct3_in)
                    `ALU_ADDI: begin
                        alu_op_select_out = 4'b0000; // ADDI
                        // Control signals for ADDI
                    end
                    `ALU_ANDI: begin
                        alu_op_select_out = 4'b0010; // ANDI
                        // Control signals for ANDI
                    end
                    `ALU_ORI: begin
                        alu_op_select_out = 4'b0011; // ORI
                        // Control signals for ORI
                    end
                    `ALU_XORI: begin
                        alu_op_select_out = 4'b1001; // XORI
                        // Control signals for XORI
                    end
                    `ALU_SLTI: begin
                        alu_op_select_out = 4'b0101; // SLTI
                        // Control signals for SLTI
                    end
                    `ALU_SLTIU: begin
                        alu_op_select_out = 4'b1000; // SLTIU
                        // Control signals for SLTIU
                    end
                    `ALU_SLLI: begin
                        alu_op_select_out = 4'b0111; // SLLI
                        // Control signals for SLLI
                    end
                    `ALU_SRLI: begin
                        alu_op_select_out = 4'b0110; // SRLI
                        // Control signals for SRLI
                    end
                    `ALU_SRAI: begin
                        alu_op_select_out = 4'b0100; // SRAI
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
                   // Default values for control signals it prevent latches 
        imm_extend_op_select_out = 3'b000;
        alu_src_a_select_out = 1'b0;
        alu_src_b_select_out = 1'b0;
        alu_op_select_out = 4'b0000;
        mem_to_reg_select_out = 2'b00;
        is_jalr_out = 1'b0;
        mem_read_enable_out = 1'b0;
        mem_write_enable_out = 1'b0;

        reg_write_enable_out = 1'b0;
        result_source_select_out = 2'b00;

        branch_enable_out = 1'b0;
        jump_enable_out = 1'b0;
            end
        endcase
    end



endmodule
