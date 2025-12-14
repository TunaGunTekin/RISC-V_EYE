`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: pc_eye.sv
// Module: Program Counter 32-bit FETCH STAGE TOTAL 
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////


module pc_eye(
    input  logic                   clk,
    input  logic                   reset,

    input logic                    stall_in,                  // Stall Signal from Hazard Unit   

    input  logic                   pc_source_execute_in,      // Branch Control Signal from Execute Stage
    input  logic [`DATA_WIDTH-1:0] pc_target_execute_in,        // Target PC from Execute Stage


    output logic [`DATA_WIDTH-1:0] instruction_fetched_out,    // Instruction fetched from Instruction Memory
    output logic [`DATA_WIDTH-1:0] pc_current_out,       // Current PC value
    output logic [`DATA_WIDTH-1:0] pc_plus_four_out   // Current PC + 4 value (to be sent to Pipeline register)
    );

    logic [`DATA_WIDTH-1:0] pc_next;

    assign pc_next = pc_source_execute_in ? pc_target_execute_in : pc_plus_four_out;
    assign pc_plus_four_out = pc_current_out + 32'd4;

    always_ff @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            pc_current_out <= '0;
        end else if (stall_in) begin
            // Hazard Unit "DUR" dediğinde PC değerini koru.
            // Böylece aynı komut tekrar tekrar fetch edilir (pipeline donar).
            pc_current_out <= pc_current_out; 
        end else begin
            pc_current_out <= pc_next;
        end
    end

    instruction_memory_eye instruction_memory (
        .addr_in(pc_current_out),
        .instruction_out(instruction_fetched_out)
    );


endmodule
