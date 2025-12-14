`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: pipeline_reg_mem_wb_eye.sv
// Module: Register between MEM and WB Stages
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////

module pipeline_reg_mem_wb_eye(
    input logic        clk,
    input logic        reset,

    //Hazard Unit Signals
    input logic        clear_in,   // If branch clear the pipeline register
    input logic        stall_in, // Enable Signal from Hazard Unit 1 => Enable , 0 => Stall 

    //Inputs from MEM Stage
    input logic        reg_write_enable_in,
    input logic [1:0]  result_source_select_in,

    
    input logic [`DATA_WIDTH-1:0]     read_data_in,     // Read data from Data Memory
    input logic [`DATA_WIDTH-1:0]     alu_result_in,    // ALU result or address
    input logic [4:0]                 rd_addr_in,       // Destination Register Address
    input logic [`DATA_WIDTH-1:0]     pc_plus_four_in,  // JAL/JALR 

    //Outputs to WB Stage
    output logic [`DATA_WIDTH-1:0]     read_data_out,         
    output logic [`DATA_WIDTH-1:0]     alu_result_out,   
    output logic [4:0]                 rd_addr_out,
    output logic [`DATA_WIDTH-1:0]     pc_plus_four_out,

    output logic                       reg_write_enable_out,
    output logic [1:0]                 result_source_select_out
    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            read_data_out <= '0;
            alu_result_out <= '0;
            rd_addr_out <= 5'd0;
            pc_plus_four_out <= '0;

            reg_write_enable_out <= 1'b0;
            result_source_select_out <= 2'b00;

        end else if (clear_in == 1'b1) begin
            read_data_out <= '0;
            alu_result_out <= '0;
            rd_addr_out <= 5'd0;
            pc_plus_four_out <= '0;

            reg_write_enable_out <= 1'b0;
            result_source_select_out <= 2'b00;

        end else if (stall_in == 1'b1) begin
            // Do nothing, stall the pipeline register
        end
        else begin
            read_data_out <= read_data_in;
            alu_result_out <= alu_result_in;
            rd_addr_out <= rd_addr_in;
            pc_plus_four_out <= pc_plus_four_in;

            reg_write_enable_out <= reg_write_enable_in;
            result_source_select_out <= result_source_select_in;
        end
    end
endmodule
