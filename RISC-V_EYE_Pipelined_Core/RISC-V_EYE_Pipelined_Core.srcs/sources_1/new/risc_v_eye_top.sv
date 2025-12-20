`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: risc_v_eye_top.sv
// Module: Top Level Module of RISC-V EYE Pipelined Core
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////


(* dont_touch = "true" *)
module risc_v_eye_top(
    input logic                    clk,
    input logic                    reset,

    // Instruction Memory Interface
    input logic [`INST_WIDTH-1:0]            instruction_memory_data_in,
    output logic [`ADDR_WIDTH-1:0]           instruction_memory_addr_out,

    // Data Memory Interface
    input logic [`DATA_WIDTH-1:0]            data_memory_read_data_in,
    input logic                              data_memory_ready_in,

    output logic [`DATA_WIDTH-1:0]           data_memory_write_data_out,
    output logic [`ADDR_WIDTH-1:0]           data_memory_addr_out,
    output logic                             data_memory_write_enable_out,
    output logic                             data_memory_read_enable_out

    // Outputs for Status Monitoring
    //output logic              trap_assert_out
    );

    // Internal signals Hazard Unit
    logic             stall_fetch_s_h;
    logic             stall_if_id_s_h;
    logic             stall_id_ex_s_h;
    logic             stall_ex_mem_s_h;
    logic             stall_mem_wb_s_h;
    logic             clear_if_id_s_h;
    logic             clear_id_ex_s_h;
    logic             clear_ex_mem_s_h;
    logic             clear_mem_wb_s_h;
    logic[1:0]        forward_a_select_s_h;
    logic[1:0]        forward_b_select_s_h;
    logic             mem_stage_stall_s_h;

    //Feedback to Fetch Stage Signals
    logic                   pc_source_execute_s;
    logic [`DATA_WIDTH-1:0] pc_target_s_e;

    //Fetch to IF-ID Register Signals
    logic [`DATA_WIDTH-1:0] instruction_fetched_s_f;
    logic [`DATA_WIDTH-1:0] pc_current_s_f;
    logic [`DATA_WIDTH-1:0] pc_plus_four_s_f;

    //ID-EX Register to Decode
    logic [`DATA_WIDTH-1:0]      instruction_decode_s_d;
    logic [`DATA_WIDTH-1:0]      pc_current_s_d;
    logic [`DATA_WIDTH-1:0]      pc_plus_four_s_d;

    //Feedback to Decode
    logic                        reg_write_enable_s_wb;
    logic [`ADDR_WIDTH-1:0]      read_addr_s_wb;
    logic [`DATA_WIDTH-1:0]      result_wb_s;

    //Control Unit to Decode
    logic [2:0]                  imm_source_select_s_d;

    //Decode to Control Unit
    logic [`OPCODE-1:0]          opcode_s_d;
    logic [`FUNCT_3-1:0]         funct3_s_d;
    logic                        funct7b5_s_d;

    //Decode to ID-EX register
    logic [`DATA_WIDTH-1:0]      read_data1_s_d;
    logic [`DATA_WIDTH-1:0]      read_data2_s_d;
    logic [`DATA_WIDTH-1:0]      imm_extended_s_d;
    logic [4:0]                  rd_addr_s_d;
    logic [4:0]                  rs1_addr_s_d;
    logic [4:0]                  rs2_addr_s_d;

    //Control Unit to ID-EX Register
    logic                        alu_src_a_select_s_d;
    logic                        alu_src_b_select_s_d;
    logic [3:0]                  alu_op_select_s_d;
    logic                        mem_read_enable_s_d;
    logic                        mem_write_enable_s_d;
    logic [1:0]                  mem_to_reg_select_s_d;
    logic                        reg_write_enable_s_d;
    logic  [1:0]                 result_source_select_s_d;
    logic                        branch_enable_s_d;
    logic                        jump_enable_s_d;
    logic                        is_jalr_s_d;
    //logic                        trap_asserted_s_d;

    // ID-EX Register to Execute Stage
    logic [`DATA_WIDTH-1:0]     read_data1_s_e;
    logic [`DATA_WIDTH-1:0]     read_data2_s_e;
    logic [`DATA_WIDTH-1:0]     imm_extended_s_e;
    logic [`DATA_WIDTH-1:0]     pc_current_s_e;
    logic [4:0]                 rd_addr_s_e;
    logic [4:0]                 rs1_addr_s_e;
    logic [4:0]                 rs2_addr_s_e;
    logic                       alu_src_a_select_s_e;
    logic                       alu_src_b_select_s_e;
    logic [3:0]                 alu_op_select_s_e;
    logic                       is_jalr_s_e;

    //WB to Execute
    //result_wb_s

    //ID-EX Register to EX-MEM Register
    logic                       mem_read_enable_s_e;
    logic                       mem_write_enable_s_e;
    logic [1:0]                 mem_to_reg_select_s_e;
    logic                       reg_write_enable_s_e;
    logic [1:0]                 result_source_select_s_e;
    logic [`DATA_WIDTH-1:0]     pc_plus_four_s_e;

    //BRANCH and JUMP Checker
    logic                       branch_enable_s_e;
    logic                       jump_enable_s_e;
    logic                       zero_flag_s_e;
   

    //Execute to Register EX-MEM
    logic [`DATA_WIDTH-1:0]    alu_result_s_e;
    logic [`DATA_WIDTH-1:0]    write_data_s_e;
    //logic [`DATA_WIDTH-1:0]    pc_target_s_e;


    // EX-MEM Register to Memory Stage
    logic                     mem_read_enable_m;
    logic                     mem_write_enable_m;
    logic [1:0]               mem_to_reg_select_m;
    logic [1:0]               result_source_select_m;
    logic [`DATA_WIDTH-1:0]   alu_result_m;
    logic [`DATA_WIDTH-1:0]   write_data_m;
    logic [4:0]               rd_addr_m;
    logic [`DATA_WIDTH-1:0]   pc_plus_four_m;
    logic                     reg_write_enable_m;

    //Memory to MEM-WB Register Signals
    logic [`DATA_WIDTH-1:0]   read_data_s_m;      // Bellekten okunan ham veri
    logic [`DATA_WIDTH-1:0]   alu_result_s_m; // Bypass edilen ALU sonucu
    logic [4:0]               rd_addr_s_m;
    logic [`DATA_WIDTH-1:0]   pc_plus_four_s_m;
    logic                     reg_write_enable_s_m;
    logic [1:0]               result_source_select_s_m;

    // MEM-WB Register to WB Stage Signals
    logic                     reg_write_enable_s_w;
    logic [1:0]               result_source_select_s_w;
    logic [`DATA_WIDTH-1:0]   read_data_s_w;
    logic [`DATA_WIDTH-1:0]   alu_result_s_w;
    logic [4:0]               rd_addr_s_w;
    logic [`DATA_WIDTH-1:0]   pc_plus_four_s_w;

    // Write Back to Feedback Stage Signals
    //logic [`DATA_WIDTH-1:0] result_wb;
    //logic reg_write_enable_s_wb;
    //logic [4:0] rd_addr_s_wb;

   // assign trap_assert_out = 1'b0;

    assign pc_source_execute_s= (branch_enable_s_e & zero_flag_s_e) | jump_enable_s_e;

    (* dont_touch = "true" *)
    hazard_unit_eye hazard_unit_inst (
         // Inputs from Decode Stage
    .rs1_addr_dec_in(rs1_addr_s_d),
    .rs2_addr_dec_in(rs2_addr_s_d),

    // Inputs from EX Stage
    .rs1_addr_ex_in(rs1_addr_s_e),
    .rs2_addr_ex_in(rs2_addr_s_e),
    .pc_src_ex_in(pc_src_select_s_e), //BRANCH


    .mem_read_enable_ex_in(mem_read_enable_s_e), //LOAD
    .rd_addr_ex_in(rd_addr_s_e),

    // Inputs from MEM Stage
    .reg_write_enable_mem_in(reg_write_enable_s_m),
    .rd_addr_mem_in(rd_addr_s_m),
    .mem_stall_mem_in(mem_stage_stall_s_h), //STALL from MEM (for load-use hazard)

    //Inputs from WB Stage
    .reg_write_enable_wb_in(reg_write_enable_s_w),
    .rd_addr_wb_in(rd_addr_s_w),

    // Outputs 
    // 00: Reg, 01: EX/MEM (Memory), 10: MEM/WB (WB)
    .forward_a_select_out(forward_a_select_s_h),
    .forward_b_select_out(forward_b_select_s_h),

    .stall_fetch_out(stall_fetch_s_h),
    .stall_if_id_out(stall_if_id_s_h),
    .stall_id_ex_out(stall_id_ex_s_h),
    .stall_ex_mem_out(stall_ex_mem_s_h),
    .stall_mem_wb_out(stall_mem_wb_s_h),
    .clear_if_id_out(clear_if_id_s_h),
    .clear_id_ex_out(clear_id_ex_s_h),
    .clear_ex_mem_out(clear_ex_mem_s_h),
    .clear_mem_wb_out(clear_mem_wb_s_h)
    );

    (* dont_touch = "true" *)
    pc_eye fetch_stage_inst (
    .clk(clk),
    .reset(reset),

    .stall_in(stall_fetch_s_h),                  // Stall Signal from Hazard Unit   

    .pc_source_execute_in(pc_source_execute_s),      // Branch Control Signal from Execute Stage
    .pc_target_execute_in(pc_target_s_e),        // Target PC from Execute Stage


    .instruction_fetched_out(instruction_fetched_s_f),    // Instruction fetched from Instruction Memory
    .pc_current_out(pc_current_s_f),       // Current PC value
    .pc_plus_four_out(pc_plus_four_s_f)   // Current PC + 4 value (to be sent to Pipeline register)
    );
    
    (* dont_touch = "true" *)
    pipeline_reg_if_id_eye if_id_register_inst (
        .clk(clk),
        .reset(reset),

        // Hazard Unit Signals
        .stall_in(stall_if_id_s_h),
        .clear_in(clear_if_id_s_h),

        // Inputs from Fetch Stage
        .instruction_fetched_in(instruction_fetched_s_f),
        .pc_current_in(pc_current_s_f),
        .pc_plus_four_in(pc_plus_four_s_f),

        // Outputs to Decode Stage
        .instruction_decode_out(instruction_decode_s_d),
        .pc_current_out(pc_current_s_d),
        .pc_plus_four_out(pc_plus_four_s_d)
    );
    
    (* dont_touch = "true" *)
    decode_stage_eye decode_stage_inst (
        .clk(clk),
        .reset(reset),

        // Inputs from IF-ID Register
        .instruction_decode_in(instruction_decode_s_d),
        .pc_plus_four_in(pc_plus_four_s_d),
        .pc_current_in(pc_current_s_d),

        // Inputs WB Stage for Register File Write Back
        .reg_write_enable_wb_in(reg_write_enable_s_w),
        .write_addr_wb_in(rd_addr_s_w),
        .write_data_wb_in(result_wb_s),

        // Inputs from Control Unit
        .imm_source_select_in(imm_source_select_s_d),

        // Outputs to ID-EX Register
        .read_data1_out(read_data1_s_d),
        .read_data2_out(read_data2_s_d),
        .imm_extended_out(imm_extended_s_d),
        .rd_addr_out(rd_addr_s_d),
        .rs1_addr_out(rs1_addr_s_d),
        .rs2_addr_out(rs2_addr_s_d),

        //Outputs to Control Unit
        .opcode_out(opcode_s_d),
        .funct3_out(funct3_s_d),
        .funct7b5_out(funct7b5_s_d)
    );
    
    (* dont_touch = "true" *)
    control_unit_eye control_unit_inst (
        .opcode_in(opcode_s_d),
        .funct3_in(funct3_s_d),
        .funct7b5_in(funct7b5_s_d),

        //Execute Stage Control Signals 
        .imm_extend_op_select_out(imm_source_select_s_d),
        .alu_src_a_select_out(alu_src_a_select_s_d), // 0: Rs1, 1: PC (AUIPC/JAL)
        .alu_src_b_select_out(alu_src_b_select_s_d), // 0: Rs2, 1: Immediate
        .alu_op_select_out(alu_op_select_s_d),
        .is_jalr_out(is_jalr_s_d),

    //Memory Stage Control Signals
        .mem_read_enable_out(mem_read_enable_s_d),
        .mem_write_enable_out(mem_write_enable_s_d),
        .mem_to_reg_select_out(mem_to_reg_select_s_d),

    //Write Back Stage Control Signals
        .reg_write_enable_out(reg_write_enable_s_d),
        .result_source_select_out(result_source_select_s_d),

    //Hazard Unit Signals
        .branch_enable_out(branch_enable_s_d),
        .jump_enable_out(jump_enable_s_d)
    );
    
    (* dont_touch = "true" *)
    pipeline_reg_id_ex_eye id_ex_register_inst (
        .clk(clk),
        .reset(reset),

        //Hazard Unit Signals
        .clear_in(clear_id_ex_s_h),
        .stall_in(stall_id_ex_s_h),

        //Inputs from ID Stage
        .read_data1_in(read_data1_s_d),
        .read_data2_in(read_data2_s_d),
        .imm_extended_in(imm_extended_s_d),
        .pc_current_in(pc_current_s_d),
        .pc_plus_four_in(pc_plus_four_s_d),

        .rd_addr_in(rd_addr_s_d),
        .rs1_addr_in(rs1_addr_s_d),
        .rs2_addr_in(rs2_addr_s_d),

        //Control Signals from Control Unit
        .alu_src_a_select_in(alu_src_a_select_s_d),
        .alu_src_b_select_in(alu_src_b_select_s_d),
        .alu_op_select_in(alu_op_select_s_d),
        .mem_read_enable_in(mem_read_enable_s_d),
        .mem_write_enable_in(mem_write_enable_s_d),
        .mem_to_reg_select_in(mem_to_reg_select_s_d),
        .reg_write_enable_in(reg_write_enable_s_d),
        .branch_enable_in(branch_enable_s_d),
        .jump_enable_in(jump_enable_s_d),
        .result_source_select_in(result_source_select_s_d),
        .is_jalr_in(is_jalr_s_d),

    //Outputs to EX Stage
        .read_data1_out(read_data1_s_e),
        .read_data2_out(read_data2_s_e),
        .imm_extended_out(imm_extended_s_e),
        .pc_current_out(pc_current_s_e),
        .pc_plus_four_out(pc_plus_four_s_e),

        .rd_addr_out(rd_addr_s_e),
        .rs1_addr_out(rs1_addr_s_e),
        .rs2_addr_out(rs2_addr_s_e),
        .alu_src_a_select_out(alu_src_a_select_s_e),
        .alu_src_b_select_out(alu_src_b_select_s_e),
        .alu_op_select_out(alu_op_select_s_e),

        .mem_read_enable_out(mem_read_enable_s_e),
        .mem_write_enable_out(mem_write_enable_s_e),
        .mem_to_reg_select_out(mem_to_reg_select_s_e),
        .reg_write_enable_out(reg_write_enable_s_e),
        .branch_enable_out(branch_enable_s_e),
        .jump_enable_out(jump_enable_s_e),
        .result_source_select_out(result_source_select_s_e),
        .is_jalr_out(is_jalr_s_e)
    );

    (* dont_touch = "true" *)
    execute_stage_eye execute_stage_inst (
        .read_data1_in(read_data1_s_e),
        .read_data2_in(read_data2_s_e),
        .imm_extended_in(imm_extended_s_e),
        .pc_current_in(pc_current_s_e),
        .pc_plus_four_in(pc_plus_four_s_e),
        .alu_src_b_select_in(alu_src_b_select_s_e),
        .alu_src_a_select_in(alu_src_a_select_s_e),
        .alu_op_select_in(alu_op_select_s_e),
        .is_jalr_in(is_jalr_s_e),

        //HAZARD UNIT SIGNALS FOR FORWARDING 
        .forward_a_select_in(forward_a_select_s_h),
        .forward_b_select_in(forward_b_select_s_h),
        .result_wb_in(result_wb_s),
        .alu_result_mem_in(alu_result_s_m),

        //Outputs to MEM Stage
        .alu_result_out(alu_result_s_e),
        .zero_flag_out(zero_flag_s_e),
        .write_data_out(write_data_s_e),
        .pc_target_out(pc_target_s_e)
    );

    (* dont_touch = "true" *)
    pipeline_reg_ex_mem_eye ex_mem_register_inst (
        .clk(clk),
        .reset(reset),

        //Hazard Unit Signals
        .clear_in(clear_ex_mem_s_h),   // If branch clear the pipeline register
        .stall_in(stall_ex_mem_s_h),   // Stall Signal from Hazard Unit 1 => Stall

    //Inputs from EX Stage
        .mem_read_enable_in(mem_read_enable_s_e),
        .mem_write_enable_in(mem_write_enable_s_e),
        .mem_to_reg_select_in(mem_to_reg_select_s_e),
        .reg_write_enable_in(reg_write_enable_s_e),
        .result_source_select_in(result_source_select_s_e),
        .alu_result_in(alu_result_s_e),
        .write_data_in(write_data_s_e),
        .rd_addr_in(rd_addr_s_e),
        .pc_plus_four_in(pc_plus_four_s_e),

    //Outputs to MEM Stage
        .mem_read_enable_out(mem_read_enable_m),
        .mem_write_enable_out(mem_write_enable_m),
        .mem_to_reg_select_out(mem_to_reg_select_m),
        .reg_write_enable_out(reg_write_enable_m),
        .result_source_select_out(result_source_select_m),

        .alu_result_out(alu_result_m),
        .write_data_out(write_data_m),
        .rd_addr_out(rd_addr_m),
        .pc_plus_four_out(pc_plus_four_m)
    );

    (* dont_touch = "true" *)
    memory_stage_eye memory_stage_inst (

       //Inputs from EX-MEM Register
        .mem_read_enable_in(mem_read_enable_m),
        .mem_write_enable_in(mem_write_enable_m),
        .mem_to_reg_select_in(mem_to_reg_select_m),
        .reg_write_enable_in(reg_write_enable_m),
        .result_source_select_in(result_source_select_m),
        .alu_result_in(alu_result_m),
        .write_data_in(write_data_m),
        .rd_addr_in(rd_addr_m),
        .pc_plus_four_in(pc_plus_four_m),

        .dmem_read_data_in(data_memory_read_data_in),
        .dmem_ready_in(data_memory_ready_in),

        .dmem_address_out(data_memory_addr_out),
        .dmem_write_data_out(data_memory_write_data_out),
        .dmem_write_enable_out(data_memory_write_enable_out),
        .dmem_read_enable_out(data_memory_read_enable_out),

    // Hazard Unit Signals
        .mem_stage_stall_out(mem_stage_stall_s_h),

    // Outputs to MEM-WB Pipeline
        .read_data_out(read_data_s_m),
        .alu_result_pass_out(alu_result_s_m),
        .rd_addr_out(rd_addr_s_m),
        .pc_plus_four_out(pc_plus_four_s_m),

        .reg_write_enable_out(reg_write_enable_s_m),
        .result_source_select_out(result_source_select_s_m)
    );

    (* dont_touch = "true" *)
    pipeline_reg_mem_wb_eye mem_wb_register_inst (
        .clk(clk),
        .reset(reset),

        //Hazard Unit Signals
        .clear_in(clear_mem_wb_s_h),   // If branch clear the pipeline register
        .stall_in(stall_mem_wb_s_h),   // Stall Signal from Hazard Unit 1 => Stall

        //Inputs from MEM Stage
        .reg_write_enable_in(reg_write_enable_s_m),
        .result_source_select_in(result_source_select_s_m),

        .read_data_in(read_data_s_m),
        .alu_result_in(alu_result_s_m),
        .rd_addr_in(rd_addr_s_m),
        .pc_plus_four_in(pc_plus_four_s_m),

        //Outputs to WB Stage
        .read_data_out(read_data_s_w),
        .alu_result_out(alu_result_s_w),
        .rd_addr_out(rd_addr_s_w),
        .pc_plus_four_out(pc_plus_four_s_w),

        .reg_write_enable_out(reg_write_enable_s_w),
        .result_source_select_out(result_source_select_s_w)
    );

    (* dont_touch = "true" *)
    writeback_stage_eye writeback_stage_inst (
        .reg_write_enable_in(reg_write_enable_s_w),
        .result_source_select_in(result_source_select_s_w),

        .read_data_in(read_data_s_w),
        .alu_result_in(alu_result_s_w),
        .rd_addr_in(rd_addr_s_w),
        .pc_plus_four_in(pc_plus_four_s_w),

        // Outputs
        .result_wb_out(result_wb_s),
        .rd_addr_out(read_addr_s_wb),
        .reg_write_enable_out(reg_write_enable_s_wb) 
    );
endmodule

