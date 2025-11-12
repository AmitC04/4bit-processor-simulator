`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    09:29:44 11/11/25
// Design Name:    
// Module Name:    ram_16x4_sync
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
module ram_16x4(
    input [3:0] addr,
    input [3:0] datain,
    input csn,               // 0 = memory in use
    input rwn,               // 1 = read, 0 = write
    output [3:0] dataout
);
    reg [3:0] memory [0:15];
    integer i;
    
    // Initialize memory
    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            memory[i] = 4'b0000;
        end
    end
    
    // Write operation
    always @(*) begin
        if (!csn && !rwn) begin
            memory[addr] = datain;
        end
    end
    
    // Read operation with tri-state output
    assign dataout = (!csn && rwn) ? memory[addr] : 4'bZZZZ;
endmodule


