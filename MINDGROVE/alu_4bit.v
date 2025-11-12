`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    09:25:01 11/11/25
// Design Name:    
// Module Name:    alu_4bit
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
module alu_4bit(
    input [2:0] sel,      // S2, S1, S0
    input [3:0] a,
    input [3:0] b,
    input cin,
    output reg [3:0] f,
    output reg cout
);
    wire [3:0] adder_out;
    wire adder_cout;
    wire [3:0] b_modified;
    wire cin_modified;
    wire [3:0] xor_result;
    
    // Generate XOR result
    xor_gate xg0(.a(a[0]), .b(b[0]), .c(xor_result[0]));
    xor_gate xg1(.a(a[1]), .b(b[1]), .c(xor_result[1]));
    xor_gate xg2(.a(a[2]), .b(b[2]), .c(xor_result[2]));
    xor_gate xg3(.a(a[3]), .b(b[3]), .c(xor_result[3]));
    
    // Modify b and cin based on operation
    assign b_modified = (sel[2:1] == 2'b00) ? 
                        ((sel[0] == 1'b0 && cin == 1'b0) ? 4'b0000 :  // Transfer a
                         (sel[0] == 1'b0 && cin == 1'b1) ? 4'b0000 :  // Increment
                         (sel[0] == 1'b1 && cin == 1'b0) ? b :         // Add
                         b) :                                           // Add with carry
                        (sel[2:0] == 3'b010 || sel[2:0] == 3'b011) ? ~b :  // Subtract
                        (sel[2:0] == 3'b110) ? 4'b1111 :               // Decrement
                        (sel[2:0] == 3'b111) ? 4'b1111 :               // Transfer
                        b;
    
    assign cin_modified = (sel[2:1] == 2'b00) ? cin :
                          (sel[2:0] == 3'b101 || sel[2:0] == 3'b110) ? 1'b1 :
                          1'b0;
    
    // Instantiate adder
    adder_4bit adder(.a(a), .b(b_modified), .cin(cin_modified), 
                     .sum(adder_out), .cout(adder_cout));
    
    // ALU operation select
    always @(*) begin
        case(sel)
            3'b000: begin f = adder_out; cout = adder_cout; end  // Increment / Transfer
            3'b001: begin f = adder_out; cout = adder_cout; end  // Add / Add with carry
            3'b010: begin f = adder_out; cout = adder_cout; end  // Subtract
            3'b011: begin f = adder_out; cout = adder_cout; end  // Subtract with borrow
            3'b100: begin f = a & b; cout = 1'b0; end            // AND
            3'b101: begin f = a | b; cout = 1'b0; end            // OR
            3'b110: begin f = xor_result; cout = 1'b0; end       // XOR
            3'b111: begin f = ~a; cout = 1'b0; end               // NOT
            default: begin f = 4'b0000; cout = 1'b0; end
        endcase
    end
endmodule

