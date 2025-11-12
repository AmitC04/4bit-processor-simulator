`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:37:56 11/11/2025
// Design Name:   xor_gate
// Module Name:   xor_gate_tb.v
// Project Name:  mindgrove
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: xor_gate
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module xor_gate_tb_v;

	// Inputs
	reg a;
	reg b;

	// Outputs
	wire c;

// Instantiate XOR gate
    xor_gate uut(.a(a), .b(b), .c(c));
    
    initial begin
        $display("============================================");
        $display("STEP 1: Testing XOR Gate (Behavioral)");
        $display("============================================");
        $display("Time\ta\tb\tc\tExpected");
        $display("----\t-\t-\t-\t--------");
        
        // Test all input combinations
        a = 0; b = 0; #10;
        $display("%0t\t%b\t%b\t%b\t0", $time, a, b, c);
        if (c !== 1'b0) $display("ERROR: Expected 0");
        
        a = 0; b = 1; #10;
        $display("%0t\t%b\t%b\t%b\t1", $time, a, b, c);
        if (c !== 1'b1) $display("ERROR: Expected 1");
        
        a = 1; b = 0; #10;
        $display("%0t\t%b\t%b\t%b\t1", $time, a, b, c);
        if (c !== 1'b1) $display("ERROR: Expected 1");
        
        a = 1; b = 1; #10;
        $display("%0t\t%b\t%b\t%b\t0", $time, a, b, c);
        if (c !== 1'b0) $display("ERROR: Expected 0");
        
        $display("\nXOR Gate Test PASSED!\n");
        $finish;
    end
endmodule


