`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    09:25:29 11/11/25
// Design Name:    
// Module Name:    registered_alu
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
module registered_alu(
    input clk,
    input reset_n,
    input [2:0] sel,
    input [3:0] a,
    input [3:0] b,
    input cin,
    output reg [3:0] f,
    output reg cout
);
    wire [3:0] alu_f;
    wire alu_cout;
    
    // Instantiate ALU
    alu_4bit alu(.sel(sel), .a(a), .b(b), .cin(cin), .f(alu_f), .cout(alu_cout));
    
    // Register outputs
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            f <= 4'b0000;
            cout <= 1'b0;
        end else begin
            f <= alu_f;
            cout <= alu_cout;
        end
    end
endmodule

