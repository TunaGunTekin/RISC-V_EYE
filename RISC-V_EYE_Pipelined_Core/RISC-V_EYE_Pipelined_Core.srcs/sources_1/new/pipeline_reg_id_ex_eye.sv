`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: pipeline_reg_id_ex_eye.sv
// Module: Register between ID and EX Stages
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////


module pipeline_reg_id_ex_eye(
    input logic        clk,
    input logic        reset,

    //Hazard Unit Signals
    input logic        clear_in,   // If branch clear the pipeline register
    input logic        stall_in, // Stall Signal from Hazard Unit 1 => Stall 


    //Inputs from ID Stage
    input logic [`DATA_WIDTH-1:0]      read_data1_in,
    input logic [`DATA_WIDTH-1:0]      read_data2_in,
    input logic [`DATA_WIDTH-1:0]      imm_extended_in,
    input logic [`DATA_WIDTH-1:0]      pc_current_in,
    input logic [`DATA_WIDTH-1:0]      pc_plus_four_in,

    input logic [4:0]                  rd_addr_in,
    input logic [4:0]                  rs1_addr_in,
    input logic [4:0]                  rs2_addr_in,
    
    input logic                        alu_src_a_select_in,
    input logic                        alu_src_b_select_in,
    input logic [3:0]                  alu_op_select_in,
    input logic                        mem_read_enable_in,
    input logic                        mem_write_enable_in,
    input logic  [1:0]                 mem_to_reg_select_in,
    input logic                        reg_write_enable_in,
    input logic                        branch_enable_in,
    input logic                        jump_enable_in,
    input logic  [1:0]                 result_source_select_in,
    input logic                        is_jalr_in,

    //Outputs to EX Stage
    output logic [`DATA_WIDTH-1:0]     read_data1_out,
    output logic [`DATA_WIDTH-1:0]     read_data2_out,
    output logic [`DATA_WIDTH-1:0]     imm_extended_out,
    output logic [`DATA_WIDTH-1:0]     pc_current_out,
    output logic [`DATA_WIDTH-1:0]     pc_plus_four_out,

    output logic [4:0]                 rd_addr_out,
    output logic [4:0]                 rs1_addr_out,
    output logic [4:0]                 rs2_addr_out,

    output logic                       alu_src_a_select_out,
    output logic                       alu_src_b_select_out,
    output logic [3:0]                 alu_op_select_out,
    output logic                       mem_read_enable_out,
    output logic                       mem_write_enable_out,
    output logic [1:0]                 mem_to_reg_select_out,
    output logic                       reg_write_enable_out,
    output logic                       branch_enable_out,
    output logic                       jump_enable_out,
    output logic [1:0]                 result_source_select_out,
    output logic                       is_jalr_out
    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            read_data1_out <= '0;
            read_data2_out <= '0;
            imm_extended_out <= '0;
            pc_current_out <= '0;
            pc_plus_four_out <= '0;

            rd_addr_out <= 5'd0;
            rs1_addr_out <= 5'd0;
            rs2_addr_out <= 5'd0;

            alu_src_a_select_out <= 1'b0;
            alu_src_b_select_out <= 1'b0;
            alu_op_select_out <= 4'd0;
            mem_read_enable_out <= 1'b0;
            mem_write_enable_out <= 1'b0;
            mem_to_reg_select_out <= 2'd0;
            reg_write_enable_out <= 1'b0;
            branch_enable_out <= 1'b0;
            jump_enable_out <= 1'b0;
            result_source_select_out <= 2'd0;
            is_jalr_out <= 1'b0;

        end else if (clear_in == 1'b1) begin
            read_data1_out <= '0;
            read_data2_out <= '0;
            imm_extended_out <= '0;
            pc_current_out <= '0;
            pc_plus_four_out <= '0;

            rd_addr_out <= 5'd0;
            rs1_addr_out <= 5'd0;
            rs2_addr_out <= 5'd0;

            alu_src_a_select_out <= 1'b0;
            alu_src_b_select_out <= 1'b0;
            alu_op_select_out <= 4'd0;
            mem_read_enable_out <= 1'b0;
            mem_write_enable_out <= 1'b0;
            mem_to_reg_select_out <= 2'd0;
            reg_write_enable_out <= 1'b0;
            branch_enable_out <= 1'b0;
            jump_enable_out <= 1'b0;
            result_source_select_out <= 2'd0;
            is_jalr_out <= 1'b0;

        end else if (stall_in == 1'b1) begin
            //Do nothing, hold the values
        end
        else begin
            read_data1_out <= read_data1_in;
            read_data2_out <= read_data2_in;
            imm_extended_out <= imm_extended_in;
            pc_current_out <= pc_current_in;
            pc_plus_four_out <= pc_plus_four_in;

            rd_addr_out <= rd_addr_in;
            rs1_addr_out <= rs1_addr_in;
            rs2_addr_out <= rs2_addr_in;

            alu_src_a_select_out <= alu_src_a_select_in;
            alu_src_b_select_out <= alu_src_b_select_in;
            alu_op_select_out <= alu_op_select_in;
            mem_read_enable_out <= mem_read_enable_in;
            mem_write_enable_out <= mem_write_enable_in;
            mem_to_reg_select_out <= mem_to_reg_select_in;
            reg_write_enable_out <= reg_write_enable_in;
            branch_enable_out <= branch_enable_in;
            jump_enable_out <= jump_enable_in;
            result_source_select_out <= result_source_select_in;
            is_jalr_out <= is_jalr_in;
        end
    end

endmodule
