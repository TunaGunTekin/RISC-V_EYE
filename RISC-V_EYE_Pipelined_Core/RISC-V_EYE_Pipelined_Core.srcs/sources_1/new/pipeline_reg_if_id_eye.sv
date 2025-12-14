`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: pipeline_reg_if_id_eye.sv
// Module: Register between IF and ID Stages
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////


module pipeline_reg_if_id_eye(
    input logic        clk,
    input logic        reset,

    //Hazard Unit Signals
    input logic        clear_in,   // If branch clear the pipeline register
    input logic        enable_in, // Enable Signal from Hazard Unit 1 => Enable , 0 => Stall 

    //Inputs from IF Stage
    input logic [31:0] instruction_fetched_in,
    input logic [31:0] pc_plus_four_in,
    input logic [31:0] pc_current_in,

    //Outputs to ID Stage
    output logic [31:0] instruction_decode_out,
    output logic [31:0] pc_plus_four_out,
    output logic [31:0] pc_current_out
    );

    always_ff @(posedge clk or negedge reset) begin
        if (!reset == 1'b1) begin
            instruction_decode_out <= 32'd0;
            pc_plus_four_out <= 32'd0;
            pc_current_out <= 32'd0;

        end else if (clear_in == 1'b1) begin
            instruction_decode_out <= 32'd0;
            pc_plus_four_out <= 32'd0;
            pc_current_out <= 32'd0;

        end else if (enable_in == 1'b1) begin
            instruction_decode_out <= instruction_fetched_in;
            pc_plus_four_out <= pc_plus_four_in;
            pc_current_out <= pc_current_in;
        end
    end
endmodule
