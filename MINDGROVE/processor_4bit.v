`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    09:30:14 11/11/25
// Design Name:    
// Module Name:    processor_4bit
// Project Name:   
// Target Device:  
// Tool versions:  
// Description:
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module processor_4bit(
    input clk,
    input reset_n,
    input [10:0] instruction,
    output [3:0] result,
    output [3:0] mem_out,      // For debugging
    output [1:0] current_state
);
    // Internal signals
    wire [2:0] alu_sel;
    wire [3:0] addr;
    wire [3:0] operand;
    wire csn, rwn, alu_enable;
    wire [3:0] mem_data;
    wire [3:0] alu_result;
    wire alu_cout;
    
    // Instantiate Instruction Decoder (Step 5)
    instruction_decoder decoder(
        .clk(clk),
        .reset_n(reset_n),
        .instruction(instruction),
        .alu_sel(alu_sel),
        .addr(addr),
        .operand(operand),
        .csn(csn),
        .rwn(rwn),
        .alu_enable(alu_enable),
        .state(current_state)
    );
    
    // Instantiate Registered ALU (Step 4)
    registered_alu alu(
        .clk(clk),
        .reset_n(reset_n),
        .sel(alu_sel),
        .a(mem_data),        // Data from memory
        .b(operand),         // Immediate operand
        .cin(1'b0),
        .f(alu_result),
        .cout(alu_cout)
    );
    
    // Instantiate Synchronous RAM (Step 8)
    ram_16x4_sync ram(
        .clk(clk),
        .reset_n(reset_n),
        .addr(addr),
        .datain(alu_result),
        .csn(csn),
        .rwn(rwn),
        .dataout(mem_data)
    );
    
    // Output assignments
    assign result = alu_result;
    assign mem_out = mem_data;
endmodule