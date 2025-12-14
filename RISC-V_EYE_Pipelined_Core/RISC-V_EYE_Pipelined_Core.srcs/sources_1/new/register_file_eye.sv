`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: register_file_eye.sv
// Module: Register File 
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////


module register_file_eye(
    input logic                    clk,
    input logic                    reset,

    input logic                    write_enable_in,
    input logic [4:0]              read_addr1_in,
    input logic [4:0]              read_addr2_in,
    input logic [4:0]              write_addr_in,
    input logic [`DATA_WIDTH-1:0]  write_data_in,

    output logic [`DATA_WIDTH-1:0] read_data1_out,
    output logic [`DATA_WIDTH-1:0] read_data2_out
    );

    // Register array
    logic [`DATA_WIDTH-1:0] registers [0:`NUM_REGISTER-1];

    // Read operations
    assign read_data1_out = (read_addr1_in == 5'b0) ? 32'b0 : registers[read_addr1_in];
    assign read_data2_out = (read_addr2_in == 5'b0) ? 32'b0 : registers[read_addr2_in];
    // Write operations
    always_ff @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            for (int i = 0; i < 32; i++) begin // Initialize all registers to 0 on reset Can be skipped for synthesis tools that auto-initialize 
                registers[i] <= 32'b0; // Synthesis tools may optimize this away also don't use for asic designs
            end
        end else if (write_enable_in && write_addr_in != 0) begin
            registers[write_addr_in] <= write_data_in;
        end
    end

    
endmodule
