`timescale 1ns / 1ps
`include "parameters.vh"
//////////////////////////////////////////////////////////////////////////////////
// Project Name: RISC-V EYE
// Description: Real-Time Object Detection on FPGA Using RISC-V Architecture Graduation Project for Hacettepe University Electrical and Electronics Engineering. 
// File Name: hazard_unit_eye.sv
// Module: Hazard Unit 
// Designer: Tuna Gün Tekin
//////////////////////////////////////////////////////////////////////////////////



module hazard_unit_eye(
    // Inputs from Decode Stage
    input logic[4:0]       rs1_addr_dec_in,
    input logic[4:0]       rs2_addr_dec_in,

    // Inputs from EX Stage
    input logic[4:0]       rs1_addr_ex_in,
    input logic[4:0]       rs2_addr_ex_in,
    input logic            pc_src_ex_in, //BRANCH

    input logic            mem_read_enable_ex_in, //LOAD
    input logic[4:0]       rd_addr_ex_in,

    // Inputs from MEM Stage
    input logic            reg_write_enable_mem_in,
    input logic[4:0]       rd_addr_mem_in,
    input logic            mem_stall_mem_in, //STALL from MEM (for load-use hazard)

    //Inputs from WB Stage
    input logic            reg_write_enable_wb_in,
    input logic[4:0]       rd_addr_wb_in,

    // Outputs 
    // 00: Reg, 01: EX/MEM (Memory), 10: MEM/WB (WB)
    output logic[1:0]        forward_a_select_out,
    output logic[1:0]        forward_b_select_out,  

    output logic             stall_fetch_out,
    output logic             stall_if_id_out,
    output logic             stall_id_ex_out,
    output logic             stall_ex_mem_out,
    output logic             stall_mem_wb_out,
    output logic             clear_if_id_out,
    output logic             clear_id_ex_out,
    output logic             clear_ex_mem_out,
    output logic             clear_mem_wb_out
    );

    logic lw_hazard;

    // Forwarding Unit
    always_comb begin 
        // Default value 
        forward_a_select_out = 2'b00;
        
        if ((reg_write_enable_mem_in == 1'b1) && (rd_addr_mem_in != 5'd0) && 
            (rd_addr_mem_in == rs1_addr_ex_in)) begin
            forward_a_select_out = 2'b01; // Forward from MEM Stage
        end else if ((reg_write_enable_wb_in == 1'b1) && (rd_addr_wb_in != 5'd0) && 
                     (rd_addr_wb_in == rs1_addr_ex_in)) begin
            forward_a_select_out = 2'b10; // Forward from WB Stage
        end
    end 

    always_comb begin
        // Default value
        forward_b_select_out = 2'b00;
        
        if ((reg_write_enable_mem_in == 1'b1) && (rd_addr_mem_in != 5'd0) && 
            (rd_addr_mem_in == rs2_addr_ex_in)) begin
            forward_b_select_out = 2'b01; // Forward from MEM Stage
        end else if ((reg_write_enable_wb_in == 1'b1) && (rd_addr_wb_in != 5'd0) && 
                     (rd_addr_wb_in == rs2_addr_ex_in)) begin
            forward_b_select_out = 2'b10; // Forward from WB Stage
        end
    end

    always_comb begin
        // Load-Use Hazard Detection
        if ((mem_read_enable_ex_in == 1'b1)  && ((rd_addr_ex_in == rs1_addr_dec_in) || (rd_addr_ex_in == rs2_addr_dec_in))) begin
            lw_hazard = 1'b1;
        end else begin
            lw_hazard = 1'b0;
        end
    end
    
    always_comb begin
        // Default values
        stall_if_id_out = 1'b0;
        stall_id_ex_out = 1'b0;
        stall_ex_mem_out = 1'b0;
        stall_mem_wb_out = 1'b0;

        clear_if_id_out = 1'b0;
        clear_id_ex_out = 1'b0;
        clear_ex_mem_out = 1'b0;
        clear_mem_wb_out = 1'b0;

        if (lw_hazard == 1'b1) begin
            // Stall the pipeline for Load-Use Hazard
            stall_fetch_out = 1'b1;
            stall_if_id_out = 1'b1;
            stall_id_ex_out = 1'b1;

            clear_id_ex_out = 1'b1; // Insert bubble in EX stage

        end else if (pc_src_ex_in == 1'b1) begin
            // Branch taken, flush IF-ID and ID-EX
            clear_if_id_out = 1'b1;
            clear_id_ex_out = 1'b1;

        end else if (mem_stall_mem_in == 1'b1) begin
            // Stall due to memory operation in MEM stage
            stall_fetch_out = 1'b1;
            stall_if_id_out = 1'b1;
            stall_id_ex_out = 1'b1;
            stall_ex_mem_out = 1'b1;
            stall_mem_wb_out = 1'b1;
        end
    end

endmodule
