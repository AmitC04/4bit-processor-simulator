`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:52:22 11/11/2025
// Design Name:   adder_4bit
// Module Name:   adder_4bit_tb.v
// Project Name:  mindgrove
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adder_4bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module adder_4bit_tb_v;

	// Inputs
	reg [3:0] a;
	reg [3:0] b;
	reg cin;

	// Outputs
	wire [3:0] sum;
	wire cout;

	// Instantiate the Unit Under Test (UUT)
	adder_4bit uut (
		.a(a), 
		.b(b), 
		.cin(cin), 
		.sum(sum), 
		.cout(cout)
	);

initial begin
        // Display header
        $display("Time(ns)\tA\tB\tCin\t|\tSum\tCout");
        $display("-------------------------------------------");

        // Apply test cases
        a = 4'b0000; b = 4'b0000; cin = 0; #10;
        $display("%0dns\t%b\t%b\t%b\t|\t%b\t%b", $time, a, b, cin, sum, cout);

        a = 4'b0001; b = 4'b0010; cin = 0; #10;
        $display("%0dns\t%b\t%b\t%b\t|\t%b\t%b", $time, a, b, cin, sum, cout);

        a = 4'b0101; b = 4'b0011; cin = 0; #10;
        $display("%0dns\t%b\t%b\t%b\t|\t%b\t%b", $time, a, b, cin, sum, cout);

        a = 4'b0111; b = 4'b0001; cin = 1; #10;
        $display("%0dns\t%b\t%b\t%b\t|\t%b\t%b", $time, a, b, cin, sum, cout);

        a = 4'b1111; b = 4'b0001; cin = 0; #10;
        $display("%0dns\t%b\t%b\t%b\t|\t%b\t%b", $time, a, b, cin, sum, cout);

        a = 4'b1111; b = 4'b1111; cin = 1; #10;
        $display("%0dns\t%b\t%b\t%b\t|\t%b\t%b", $time, a, b, cin, sum, cout);

        // Finish simulation
        $display("-------------------------------------------");
        $finish;
    end

endmodule