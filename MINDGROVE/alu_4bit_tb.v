`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:56:00 11/11/2025
// Design Name:   alu_4bit
// Module Name:   alu_4bit_tb.v
// Project Name:  mindgrove
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu_4bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module alu_4bit_tb_v;

    // Inputs
    reg [2:0] sel;
    reg [3:0] a;
    reg [3:0] b;
    reg cin;

    // Outputs
    wire [3:0] f;
    wire cout;

    // Instantiate the Unit Under Test (UUT)
    alu_4bit uut (
        .sel(sel), 
        .a(a), 
        .b(b), 
        .cin(cin), 
        .f(f), 
        .cout(cout)
    );

    // Task for formatted output display
    task display_output;
        begin
            $display("Time=%0dns | SEL=%b | A=%b | B=%b | CIN=%b | F=%b | COUT=%b",
                     $time, sel, a, b, cin, f, cout);
        end
    endtask

    initial begin
        // Header
        $display("--------------- 4-BIT ALU TESTBENCH ---------------");
        $display("SEL\tA\tB\tCIN\t|\tF\tCOUT\tOperation");
        $display("----------------------------------------------------");

        // Test 1: ADD
        sel = 3'b001; a = 4'b0101; b = 4'b0011; cin = 0; #10;
        display_output(); $display("Operation: ADD");

        // Test 2: ADD with carry
        sel = 3'b001; a = 4'b0110; b = 4'b0100; cin = 1; #10;
        display_output(); $display("Operation: ADD with Carry");

        // Test 3: SUBTRACT (A - B)
        sel = 3'b010; a = 4'b1000; b = 4'b0011; cin = 0; #10;
        display_output(); $display("Operation: SUBTRACT");

        // Test 4: INCREMENT A
        sel = 3'b000; a = 4'b0100; b = 4'b0000; cin = 1; #10;
        display_output(); $display("Operation: INCREMENT");

        // Test 5: DECREMENT A
        sel = 3'b011; a = 4'b0110; b = 4'b0000; cin = 0; #10;
        display_output(); $display("Operation: DECREMENT");

        // Test 6: AND
        sel = 3'b100; a = 4'b1101; b = 4'b1010; cin = 0; #10;
        display_output(); $display("Operation: AND");

        // Test 7: OR
        sel = 3'b101; a = 4'b1101; b = 4'b1010; cin = 0; #10;
        display_output(); $display("Operation: OR");

        // Test 8: XOR
        sel = 3'b110; a = 4'b1100; b = 4'b1010; cin = 0; #10;
        display_output(); $display("Operation: XOR");

        // Test 9: NOT
        sel = 3'b111; a = 4'b1100; b = 4'b0000; cin = 0; #10;
        display_output(); $display("Operation: NOT");

        // End Simulation
        $display("----------------------------------------------------");
        $finish;
    end

endmodule
