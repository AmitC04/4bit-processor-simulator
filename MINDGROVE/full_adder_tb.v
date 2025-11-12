`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:35:12 11/10/2025
// Design Name:   full_adder
// Module Name:   full_adder_tb.v
// Project Name:  MINDGROVE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: full_adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module full_adder_tb;

reg a, b, cin;
wire sum, cout;

// Instantiate the full adder
full_adder uut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

// VCD Generation - MOVED TO TOP
initial begin
    $dumpfile("full_adder.vcd");
    $dumpvars(0);
    $display("*** VCD file opened: full_adder.vcd ***");
end

// Test cases
initial begin
    $display("Time\t a\t b\t cin\t sum\t cout");
    $monitor("%0t\t %b\t %b\t %b\t %b\t %b", $time, a, b, cin, sum, cout);
    
    // Test all 8 combinations
    a = 0; b = 0; cin = 0; #10;
    a = 0; b = 0; cin = 1; #10;
    a = 0; b = 1; cin = 0; #10;
    a = 0; b = 1; cin = 1; #10;
    a = 1; b = 0; cin = 0; #10;
    a = 1; b = 0; cin = 1; #10;
    a = 1; b = 1; cin = 0; #10;
    a = 1; b = 1; cin = 1; #10;
    
    // IMPORTANT: Add delay and flush before finish
    #10;
    $display("*** Simulation complete - closing VCD ***");
    $dumpflush;  // Force write VCD data to file
    $finish;
end

endmodule