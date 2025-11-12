`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:41:12 11/11/2025
// Design Name:   processor_4bit
// Module Name:   processor_4bit_tb.v
// Project Name:  mindgrove
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: processor_4bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module processor_4bit_tb;
    reg clk, reset_n;
    reg [10:0] instruction;
    wire [3:0] result;
    wire [3:0] mem_out;
    wire [1:0] current_state;
    
    // Instantiate Processor
    processor_4bit uut(
        .clk(clk),
        .reset_n(reset_n),
        .instruction(instruction),
        .result(result),
        .mem_out(mem_out),
        .current_state(current_state)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // --- VCD DUMP FILE CONFIGURATION ---
    initial begin
        $dumpfile("processor_4bit_tb.vcd");   // Name of the VCD output file
        $dumpvars(0, processor_4bit_tb);      // Dump all signals in this module
    end
    
    // State display
    function [63:0] state_name;
        input [1:0] s;
        begin
            case(s)
                2'b00: state_name = "INIT   ";
                2'b01: state_name = "FETCH  ";
                2'b10: state_name = "EXECUTE";
                2'b11: state_name = "STORE  ";
            endcase
        end
    endfunction
    
    initial begin
        $display("============================================");
        $display("STEP 7: Testing Complete 4-bit Processor");
        $display("============================================");
        $display("\nInstruction Format: [Opcode(3)][Addr(4)][Immediate(4)]");
        $display("Opcodes: STO=000, ADD=001, SUB=010, AND=011, OR=100, XOR=101, NOT=110\n");
        
        // Reset
        reset_n = 0;
        instruction = 11'b0;
        #20;
        reset_n = 1;
        #10;
        $display("Processor initialized\n");
        
        // Assembly Program
        $display("Executing Sample Assembly Program:\n");
        
        // 1. STO [0], 5
        $display("1. STO [0], 5  - Store 5 at address 0");
        instruction = 11'b000_0000_0101;
        #30;
        $display("   Result: Memory[0] = %d\n", result);
        
        // 2. ADD [0], 3
        $display("2. ADD [0], 3  - Add 3 to address 0 (5+3=8)");
        instruction = 11'b001_0000_0011;
        #30;
        $display("   Result: Memory[0] = %d\n", result);
        
        // 3. SUB [0], 2
        $display("3. SUB [0], 2  - Subtract 2 from address 0 (8-2=6)");
        instruction = 11'b010_0000_0010;
        #30;
        $display("   Result: Memory[0] = %d\n", result);
        
        // 4. STO [1], 12
        $display("4. STO [1], 12 - Store 12 at address 1");
        instruction = 11'b000_0001_1100;
        #30;
        $display("   Result: Memory[1] = %d\n", result);
        
        // 5. AND [1], 7
        $display("5. AND [1], 7  - AND address 1 with 7 (12&7=4)");
        instruction = 11'b011_0001_0111;
        #30;
        $display("   Result: Memory[1] = %d\n", result);
        
        // 6. OR [1], 8
        $display("6. OR [1], 8   - OR address 1 with 8 (4|8=12)");
        instruction = 11'b100_0001_1000;
        #30;
        $display("   Result: Memory[1] = %d\n", result);
        
        // 7. XOR [1], 15
        $display("7. XOR [1], 15 - XOR address 1 with 15 (12^15=3)");
        instruction = 11'b101_0001_1111;
        #30;
        $display("   Result: Memory[1] = %d\n", result);
        
        // 8. NOT [1], 0
        $display("8. NOT [1], 0  - NOT value at address 1 (~3=12)");
        instruction = 11'b110_0001_0000;
        #30;
        $display("   Result: Memory[1] = %d\n", result);
        
        // Verify final values
        $display("\n--- Final Memory Check ---");
        instruction = 11'b001_0000_0000;  // Read address 0
        #30;
        $display("Memory[0] = %d (expected 6)", result);
        
        instruction = 11'b001_0001_0000;  // Read address 1
        #30;
        $display("Memory[1] = %d (expected 12)", result);
        
        $display("\n============================================");
        $display("Complete Processor Test PASSED!");
        $display("============================================\n");
        
        #50;
        $finish;
    end
    
    // Monitor state transitions
    always @(posedge clk) begin
        if (current_state != 2'b00)  // Skip INIT state
            $display("   [%0t] State: %s", $time, state_name(current_state));
    end
endmodule
