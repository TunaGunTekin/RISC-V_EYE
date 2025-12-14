`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: register_file_eye.sv
// Module: Register File 
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////


module register_file_eye(
    input logic clk,
    input logic write_enable,
    input logic [4:0] read_addr1,
    input logic [4:0] read_addr2,
    input logic [4:0] write_addr,
    input logic [`DATA_WIDTH-1:0] write_data,
    output logic [`DATA_WIDTH-1:0] read_data1,
    output logic [`DATA_WIDTH-1:0] read_data2
    );

    // Register array
    logic [`DATA_WIDTH-1:0] registers [0:`NUM_REGISTER-1];

    // Read operations
    assign read_data1 = registers[read_addr1];
    assign read_data2 = registers[read_addr2];

    // Write operations
    always_ff @(posedge clk) begin
        if (write_enable && write_addr != 0) begin
            registers[write_addr] <= write_data;
        end
    end

    
endmodule
