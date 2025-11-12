`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    09:29:02 11/11/25
// Design Name:    
// Module Name:    ram_16x4
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
// =========================================================
// 16x4 Synchronous RAM with Active-Low Reset & Chip Select
// =========================================================
// =========================================================
// Synchronous 16x4 RAM (single-port)
// Compatible with Xilinx XST / Vivado synthesis
// =========================================================
module ram_16x4_sync(
    input clk,
    input reset_n,
    input [3:0] addr,
    input [3:0] datain,
    input csn,               // 0 = memory in use
    input rwn,               // 1 = read, 0 = write
    output reg [3:0] dataout
);
    reg [3:0] memory [0:15];
    integer i;
    
    // Initialize memory
    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            memory[i] = 4'b0000;
        end
    end
    
    // Synchronous read/write operation
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            dataout <= 4'b0000;
        end else begin
            if (!csn) begin
                if (!rwn) begin
                    // Write operation
                    memory[addr] <= datain;
                end else begin
                    // Read operation
                    dataout <= memory[addr];
                end
            end
        end
    end
endmodule