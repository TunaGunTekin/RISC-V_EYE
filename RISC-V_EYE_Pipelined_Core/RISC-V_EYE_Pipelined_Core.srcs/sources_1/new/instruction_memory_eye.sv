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
        // Load instructions from an external file into instruction memory
        $readmemh("instructions.mem", instruction_memory);
    end

    assign instruction_out = instruction_memory[addr_in[31:2]];

    
endmodule
