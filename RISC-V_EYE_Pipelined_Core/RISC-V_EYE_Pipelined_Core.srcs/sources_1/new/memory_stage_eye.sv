`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: memory_stage_eye.sv
// Module: Memory Stage 
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////

module memory_stage_eye(
    //Inputs from EX-MEM Register
    input logic                      mem_read_enable_in,
    input logic                      mem_write_enable_in,
    input logic [1:0]                mem_to_reg_select_in,
    input logic                      reg_write_enable_in,
    input logic [1:0]                result_source_select_in,

    input logic [`DATA_WIDTH-1:0]    alu_result_in,
    input logic [`DATA_WIDTH-1:0]    write_data_in,
    input logic [4:0]                rd_addr_in,
    input logic [`DATA_WIDTH-1:0]    pc_plus_four_in,

    input logic  [`DATA_WIDTH-1:0]   dmem_read_data_in,
    input logic                      dmem_ready_in,

    output logic [`ADDR_WIDTH-1:0]    dmem_address_out,
    output logic [`DATA_WIDTH-1:0]    dmem_write_data_out,
    output logic                      dmem_write_enable_out, 
    output logic                      dmem_read_enable_out,

    // Hazard Unit Signals
    output logic                      mem_stage_stall_out,

    // Outputs to MEM-WB Pipeline
    output logic [`DATA_WIDTH-1:0]    read_data_out,         
    output logic [`DATA_WIDTH-1:0]    alu_result_pass_out,   
    output logic [4:0]                rd_addr_out,
    output logic [`DATA_WIDTH-1:0]    pc_plus_four_out,
    
    output logic                      reg_write_enable_out,
    output logic [1:0]                result_source_select_out
    );

   
    assign dmem_addr_out         = alu_result_in;
    assign dmem_write_data_out   = write_data_in;
    assign dmem_write_enable_out = mem_write_enable_in;
    assign dmem_read_enable_out  = mem_read_enable_in;

    
    assign read_data_out = dmem_read_data_in;

    // STALL LOGIC
    always_comb begin
        if ((mem_read_enable_in || mem_write_enable_in) && (dmem_ready_in == 1'b0)) begin
            mem_stage_stall_out = 1'b1;
        end else begin
            mem_stage_stall_out = 1'b0;
        end
    end

    // 4. Pass-Through Signals to MEM-WB Pipeline
    assign alu_result_pass_out      = alu_result_in;
    assign rd_addr_out              = rd_addr_in;
    assign pc_plus_four_out         = pc_plus_four_in;
    assign reg_write_enable_out     = reg_write_enable_in;
    assign result_source_select_out = result_source_select_in;

endmodule