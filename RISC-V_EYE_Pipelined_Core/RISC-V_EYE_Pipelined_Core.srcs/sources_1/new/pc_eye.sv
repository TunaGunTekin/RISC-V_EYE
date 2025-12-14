`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: pc_eye.sv
// Module: Program Counter 32-bit 
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////


module pc_eye(
    input  logic        clk,
    input  logic        reset,
    input  logic        pc_source_execute_in,      // Branch Control Signal from Execute Stage
    input  logic [31:0] pc_target_execute_in,        // Target PC from Execute Stage
    output logic [31:0] instruction_fetched_out,    // Instruction fetched from Instruction Memory
    output logic [31:0] pc_current_out,       // Current PC value
    output logic [31:0] pc_plus_four_out   // Current PC + 4 value (to be sent to Pipeline register)
    );

    logic [31:0] pc_next;

    assign pc_next = pc_source_execute_in ? pc_target_execute_in : pc_plus_four_out;
    assign pc_plus_four_out = pc_current_out + 32'd4;

    always_ff @(posedge clk or negedge reset) begin
        if (!reset == 1'b1) begin
            pc_current_out <= 32'd0;
        end else begin
            pc_current_out <= pc_next;
        end
    end

    instruction_memory_eye instruction_memory (
        .addr_in(pc_current_out),
        .instruction_out(instruction_fetched_out)
    );


endmodule
