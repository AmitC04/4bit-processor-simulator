`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:18:43 11/11/2025
// Design Name:   registered_alu
// Module Name:   registered_alu_tb.v
// Project Name:  mindgrove
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: registered_alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module registered_alu_tb_v;

    // Inputs
    reg clk;
    reg reset_n;
    reg [2:0] sel;
    reg [3:0] a;
    reg [3:0] b;
    reg cin;

    // Outputs
    wire [3:0] f;
    wire cout;

    // Instantiate the Unit Under Test (UUT)
    registered_alu uut (
        .clk(clk), 
        .reset_n(reset_n), 
        .sel(sel), 
        .a(a), 
        .b(b), 
        .cin(cin), 
        .f(f), 
        .cout(cout)
    );

    // Generate clock (10 ns period)
    always #5 clk = ~clk;

    // Task to display outputs neatly
    task display_output;
        begin
            $display("Time=%0dns | CLK=%b | RESET=%b | SEL=%b | A=%b | B=%b | CIN=%b | F=%b | COUT=%b",
                     $time, clk, reset_n, sel, a, b, cin, f, cout);
        end
    endtask

    initial begin
        // Initialize Inputs
        clk = 0;
        reset_n = 0;
        sel = 0;
        a = 0;
        b = 0;
        cin = 0;

        // Apply reset
        $display("Applying reset...");
        #20 reset_n = 1;  // Release reset after 20ns
        $display("Reset released at %0dns", $time);

        // Test 1: ADD
        sel = 3'b001; a = 4'b0101; b = 4'b0011; cin = 0; #20; display_output();

        // Test 2: ADD with Carry
        sel = 3'b001; a = 4'b0110; b = 4'b0100; cin = 1; #20; display_output();

        // Test 3: SUBTRACT
        sel = 3'b010; a = 4'b1000; b = 4'b0011; cin = 0; #20; display_output();

        // Test 4: INCREMENT
        sel = 3'b000; a = 4'b0100; b = 4'b0000; cin = 1; #20; display_output();

        // Test 5: DECREMENT
        sel = 3'b011; a = 4'b0101; b = 4'b0000; cin = 0; #20; display_output();

        // Test 6: AND
        sel = 3'b100; a = 4'b1101; b = 4'b1010; cin = 0; #20; display_output();

        // Test 7: OR
        sel = 3'b101; a = 4'b1101; b = 4'b1010; cin = 0; #20; display_output();

        // Test 8: XOR
        sel = 3'b110; a = 4'b1100; b = 4'b1010; cin = 0; #20; display_output();

        // Test 9: NOT
        sel = 3'b111; a = 4'b1100; b = 4'b0000; cin = 0; #20; display_output();

        // Finish simulation
        $display("----------------------------------------------------");
        $display("Simulation completed at %0dns", $time);
        $finish;
    end

endmodule
