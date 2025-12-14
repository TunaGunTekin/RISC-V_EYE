`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: memory_stage_eye.sv
// Module: Memory Stage 
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////


module writeback_stage_eye(
    //Inputs from MEM-WB Register
    input logic        reg_write_enable_in, 
    input logic [1:0]  result_source_select_in,

    
    input logic [`DATA_WIDTH-1:0]     read_data_in,     // Read data from Data Memory
    input logic [`DATA_WIDTH-1:0]     alu_result_in,    // ALU result or address
    input logic [4:0]                 rd_addr_in,       // Destination Register Address
    input logic [`DATA_WIDTH-1:0]     pc_plus_four_in,  // JAL/JALR 

    output logic [`DATA_WIDTH-1:0]     result_wb_out,
    output logic [4:0]                 rd_addr_out,
    output logic                       reg_write_enable_out

    );

    always_comb begin
        case (result_source_select_in)
            2'b00: result_wb_out = alu_result_in;          // ALU Result
            2'b01: result_wb_out = read_data_in;          // Data Memory Read Data
            2'b10: result_wb_out = pc_plus_four_in;       // PC + 4 (for JAL/JALR)
            default: result_wb_out = alu_result_in;
        endcase
    end

    assign rd_addr_out = rd_addr_in;
    assign reg_write_enable_out = reg_write_enable_in;
    
endmodule
