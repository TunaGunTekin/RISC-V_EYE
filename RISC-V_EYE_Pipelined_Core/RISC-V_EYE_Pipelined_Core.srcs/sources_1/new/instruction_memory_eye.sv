`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: instruction_memory_eye.sv
// Module: Instruction Memory 
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////



module instruction_memory_eye(
    input  logic [31:0] addr_in,
    output logic [31:0] instruction_out
    );

    // Instruction Memory Array
    logic [`INST_WIDTH-1:0] instruction_memory [0:`MEM_SIZE-1];

    initial begin
         for (int i = 0; i < 32; i++) begin // Initialize all registers to 0 on reset Can be skipped for synthesis tools that auto-initialize 
               instruction_memory[i] <= 32'b0; // Synthesis tools may optimize this away also don't use for asic designs
            end
    end

    assign instruction_out = instruction_memory[addr_in[31:2]];

    
endmodule
