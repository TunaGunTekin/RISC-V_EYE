`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: decode_stage_eye.sv
// Module: Decode Stage 
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////


module decode_stage_eye(
    input logic                    clk,
    input logic                    reset,

    // Inputs from IF-ID Register
    input logic [`DATA_WIDTH-1:0]  instruction_decode_in,
    input logic [`DATA_WIDTH-1:0]  pc_plus_four_in,
    input logic [`DATA_WIDTH-1:0]  pc_current_in,

    // Inputs WB Stage for Register File Write Back
    input logic                    reg_write_enable_wb_in,
    input logic [4:0]              write_addr_wb_in,
    input logic [`DATA_WIDTH-1:0]  write_data_wb_in,

    // Inputs from Control Unit
    input logic [2:0]              imm_source_select_in,

    // Outputs to ID-EX Register
    output logic [`DATA_WIDTH-1:0]      read_data1_out,
    output logic [`DATA_WIDTH-1:0]      read_data2_out,
    output logic [`DATA_WIDTH-1:0]      imm_extended_out,
    output logic [4:0]                  rd_addr_out,
    output logic [4:0]                  rs1_addr_out,
    output logic [4:0]                  rs2_addr_out,

    //Outputs to Control Unit
    output logic [`OPCODE-1:0]          opcode_out,
    output logic [`FUNCT_3-1:0]         funct3_out,
    output logic                        funct7b5_out
    );

    logic [31:7] instruction_field;
    assign instruction_field = instruction_decode_in[31:7];
    assign opcode_out   = instruction_decode_in[6:0];
    assign rd_addr_out  = instruction_decode_in[11:7];
    assign funct3_out   = instruction_decode_in[14:12];
    assign rs1_addr_out = instruction_decode_in[19:15];
    assign rs2_addr_out = instruction_decode_in[24:20];
    assign funct7b5_out = instruction_decode_in[30];

    register_file_eye register_file_inst (
        .clk(clk),
        .reset(reset),

        .write_enable_in(reg_write_enable_wb_in),
        .read_addr1_in(rs1_addr_out),
        .read_addr2_in(rs2_addr_out),

        .write_addr_in(write_addr_wb_in),
        .write_data_in(write_data_wb_in),

        .read_data1_out(read_data1_out),
        .read_data2_out(read_data2_out)
    );

    immediate_extender_eye immediate_extender_inst (
        .instruction_in(instruction_decode_in),
        .op_select_in(imm_source_select_in),

        .imm_extended_out(imm_extended_out)
    );

endmodule
