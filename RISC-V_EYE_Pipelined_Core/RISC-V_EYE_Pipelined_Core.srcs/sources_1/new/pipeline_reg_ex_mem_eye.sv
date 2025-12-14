`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: pipeline_reg_ex_mem_eye.sv
// Module: Register between EX and MEM Stages
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////


module pipeline_reg_ex_mem_eye(
    input logic                      clk,
    input logic                      reset,

    //Hazard Unit Signals
    input logic                      clear_in,   // If branch clear the pipeline register
    input logic                      stall_in,   // Stall Signal from Hazard Unit 1 => Stall

    //Inputs from EX Stage
    input logic                      mem_read_enable_in,
    input logic                      mem_write_enable_in,
    input logic [1:0]                mem_to_reg_select_in,
    input logic                      reg_write_enable_in,
    input logic [1:0]                result_source_select_in,

    input logic [`DATA_WIDTH-1:0]    alu_result_in,
    input logic [`DATA_WIDTH-1:0]    write_data_in,
    input logic [4:0]                rd_addr_in,
    input logic [`DATA_WIDTH-1:0]    pc_plus_four_in,

    //Outputs to MEM Stage
    output logic                     mem_read_enable_out,
    output logic                     mem_write_enable_out,
    output logic [1:0]               mem_to_reg_select_out,
    output logic                     reg_write_enable_out,
    output logic [1:0]               result_source_select_out,

    output logic [`DATA_WIDTH-1:0]   alu_result_out,
    output logic [`DATA_WIDTH-1:0]   write_data_out,
    output logic [4:0]               rd_addr_out,
    output logic [`DATA_WIDTH-1:0]   pc_plus_four_out

    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            mem_read_enable_out <= 1'b0;
            mem_write_enable_out <= 1'b0;
            mem_to_reg_select_out <= 2'b00;
            reg_write_enable_out <= 1'b0;
            result_source_select_out <= 2'b00;

            alu_result_out <= `DATA_WIDTH'd0;
            write_data_out <= `DATA_WIDTH'd0;
            rd_addr_out <= 5'd0;
            pc_plus_four_out <= `DATA_WIDTH'd0;

        end else if (clear_in == 1'b1) begin
            mem_read_enable_out <= 1'b0;
            mem_write_enable_out <= 1'b0;
            mem_to_reg_select_out <= 2'b00;
            reg_write_enable_out <= 1'b0;
            result_source_select_out <= 2'b00;

            alu_result_out <= `DATA_WIDTH'd0;
            write_data_out <= `DATA_WIDTH'd0;
            rd_addr_out <= 5'd0;
            pc_plus_four_out <= `DATA_WIDTH'd0;

        end else if (stall_in == 1'b1) begin
            //Do nothing, hold the values
            
        end else begin
            mem_read_enable_out <= mem_read_enable_in;
            mem_write_enable_out <= mem_write_enable_in;
            mem_to_reg_select_out <= mem_to_reg_select_in;
            reg_write_enable_out <= reg_write_enable_in;
            result_source_select_out <= result_source_select_in;

            alu_result_out <= alu_result_in;
            write_data_out <= write_data_in;
            rd_addr_out <= rd_addr_in;
            pc_plus_four_out <= pc_plus_four_in;
        end
    end
    
endmodule
