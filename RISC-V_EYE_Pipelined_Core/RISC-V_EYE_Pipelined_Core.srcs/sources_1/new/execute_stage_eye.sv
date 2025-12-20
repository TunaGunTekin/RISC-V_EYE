`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: execute_stage_eye.sv
// Module: Execute Stage 
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////



module execute_stage_eye(
    input logic [`DATA_WIDTH-1:0]     read_data1_in,
    input logic [`DATA_WIDTH-1:0]     read_data2_in,
    input logic [`DATA_WIDTH-1:0]     imm_extended_in,
    input logic [`DATA_WIDTH-1:0]     pc_current_in,
    input logic [`DATA_WIDTH-1:0]     pc_plus_four_in,

    input logic                       alu_src_b_select_in,
    input logic                       alu_src_a_select_in,    // 0: Reg(rs1), 1: PC (AUIPC ve JAL için)
    input logic [3:0]                 alu_op_select_in,
    
    input logic                       is_jalr_in,

    //HAZARD UNIT SIGNALS FOR FORWARDING 
    input logic  [1:0]                forward_a_select_in,
    input logic  [1:0]                forward_b_select_in,
    input logic [`DATA_WIDTH-1:0]     result_wb_in,    
    input logic [`DATA_WIDTH-1:0]     alu_result_mem_in,  

    //Outputs to MEM Stage
    output logic [`DATA_WIDTH-1:0]    alu_result_out,
    output logic                      zero_flag_out,
    output logic [`DATA_WIDTH-1:0]    write_data_out,
    output logic [`DATA_WIDTH-1:0]    pc_target_out
    );

    logic [`DATA_WIDTH-1:0] forwarded_src_a;    
    logic [`DATA_WIDTH-1:0] alu_src_a_final;    
    logic [`DATA_WIDTH-1:0] forwarded_src_b;    
    logic [`DATA_WIDTH-1:0] alu_src_b_final;    
    logic [`DATA_WIDTH-1:0] branch_target_calc;
   

    // Forwarding MUX for ALU Source A
    always_comb begin   
        case (forward_a_select_in) //hazard unit
            2'b00: forwarded_src_a = read_data1_in; // No forwarding
            2'b01: forwarded_src_a = alu_result_mem_in; // Forward from EX/MEM
            2'b10: forwarded_src_a = result_wb_in; // Forward from MEM/WB
            default: forwarded_src_a = read_data1_in; // Default case
        endcase
    end

    // Forwarding MUX for ALU Source B
    always_comb begin   
        case (forward_b_select_in) //hazard unit
            2'b00: forwarded_src_b = read_data2_in; // No forwarding
            2'b01: forwarded_src_b = alu_result_mem_in; // Forward from EX/MEM
            2'b10: forwarded_src_b = result_wb_in; // Forward from MEM/WB
            default: forwarded_src_b = read_data2_in; // Default case
        endcase
    end

    // ALU Source B MUX (Immediate or Register)
    assign alu_src_b_final = (alu_src_b_select_in) ? imm_extended_in : forwarded_src_b;

    // --- 3. ALU Source A Selection (Reg vs PC) ---
    
    assign alu_src_a_final = (alu_src_a_select_in) ? pc_current_in : forwarded_src_a;


    alu_eye alu_inst (
        .src1_in(alu_src_a_final),
        .src2_in(alu_src_b_final),
        .alu_control_in(alu_op_select_in),
        .alu_result_out(alu_result_out),
        .zero_flag_out(zero_flag_out)
    );

    assign branch_target_calc = pc_current_in + imm_extended_in;

    // Dallanma (Branch) veya Zıplama (Jump) hedef adresini hesaplar.
    assign pc_target_out = (is_jalr_in) ? {alu_result_out[`DATA_WIDTH-1:1], 1'b0} : branch_target_calc;

    // Belleğe yazılacak veri (Store işlemi için)
    assign write_data_out = forwarded_src_b;


endmodule
