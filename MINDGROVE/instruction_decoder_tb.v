`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:52:52 11/11/2025
// Design Name:   instruction_decoder
// Module Name:   instruction_decoder_tb.v
// Project Name:  mindgrove
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: instruction_decoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module instruction_decoder_tb_v;

    // Inputs
    reg clk;
    reg reset_n;
    reg [10:0] instruction;

    // Outputs
    wire [2:0] alu_sel;
    wire [3:0] addr;
    wire [3:0] operand;
    wire csn;
    wire rwn;
    wire alu_enable;
    wire [1:0] state;

    // Instantiate the Unit Under Test (UUT)
    instruction_decoder uut (
        .clk(clk), 
        .reset_n(reset_n), 
        .instruction(instruction), 
        .alu_sel(alu_sel), 
        .addr(addr), 
        .operand(operand), 
        .csn(csn), 
        .rwn(rwn), 
        .alu_enable(alu_enable), 
        .state(state)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Task for displaying results
    task display_output;
        begin
            $display("Time=%0dns | CLK=%b | RESET_N=%b | INSTR=%b | ALU_SEL=%b | ADDR=%b | OPERAND=%b | CSN=%b | RWN=%b | ALU_EN=%b | STATE=%b",
                     $time, clk, reset_n, instruction, alu_sel, addr, operand, csn, rwn, alu_enable, state);
        end
    endtask

    // Main test sequence
    initial begin
        // Initialize inputs
        clk = 0;
        reset_n = 0;
        instruction = 11'b000_0000_0000;

        $display("--------------- INSTRUCTION DECODER TESTBENCH ---------------");

        // Apply reset
        $display("Applying reset...");
        #20 reset_n = 1;
        $display("Reset released at %0dns", $time);

        // Wait a few cycles before sending instructions
        #20;

        // Test 1: ADD instruction (example: ALU op = 001, addr = 0010, operand = 0101)
        instruction = 11'b001_0010_0101; #20; display_output();

        // Test 2: SUB instruction (010)
        instruction = 11'b010_0100_0011; #20; display_output();

        // Test 3: AND instruction (100)
        instruction = 11'b100_0001_1110; #20; display_output();

        // Test 4: OR instruction (101)
        instruction = 11'b101_0011_0110; #20; display_output();

        // Test 5: XOR instruction (110)
        instruction = 11'b110_1111_0001; #20; display_output();

        // Test 6: NOT instruction (111)
        instruction = 11'b111_0100_0000; #20; display_output();

        // Test 7: Transfer instruction (000)
        instruction = 11'b000_1010_0100; #20; display_output();

        // End of simulation
        #50;
        $display("-------------------------------------------------------------");
        $display("Simulation completed at %0dns", $time);
        $finish;
    end

endmodule


