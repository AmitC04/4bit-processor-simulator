`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    09:21:58 11/11/25
// Design Name:    
// Module Name:    xor_gate
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
module xor_gate(
    input a,
    input b,
    output c
);
    // Behavioral description without using built-in xor
    assign c = (a & ~b) | (~a & b);
endmodule
