`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    09:44:27 11/11/25
// Design Name:    
// Module Name:    full_adder_1bit
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
module full_adder_1bit(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    wire xor_ab;
    wire and1, and2;
    
    // Sum = a XOR b XOR cin (using XOR gate from Step 1)
    xor_gate xg1(.a(a), .b(b), .c(xor_ab));
    xor_gate xg2(.a(xor_ab), .b(cin), .c(sum));
    
    // Carry out = (a AND b) OR (cin AND (a XOR b))
    assign and1 = a & b;
    assign and2 = cin & xor_ab;
    assign cout = and1 | and2;
endmodule

