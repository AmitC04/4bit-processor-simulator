`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    09:28:17 11/11/25
// Design Name:    
// Module Name:    instruction_decoder
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
module instruction_decoder(
    input clk,
    input reset_n,
    input [10:0] instruction,    // [opcode(3)][op1(4)][op2(4)]
    output reg [2:0] alu_sel,
    output reg [3:0] addr,
    output reg [3:0] operand,
    output reg csn,              // Chip select for RAM
    output reg rwn,              // Read/Write for RAM
    output reg alu_enable,
    output reg [1:0] state
);
    // State definitions
    localparam INIT = 2'b00;
    localparam FETCH = 2'b01;
    localparam EXECUTE = 2'b10;
    localparam STORE = 2'b11;
    
    // Instruction fields
    wire [2:0] opcode;
    wire [3:0] op1;  // Destination memory address
    wire [3:0] op2;  // Source (constant/immediate value)
    
    assign opcode = instruction[10:8];
    assign op1 = instruction[7:4];
    assign op2 = instruction[3:0];
    
    // State machine with asynchronous reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= INIT;
            alu_sel <= 3'b000;
            addr <= 4'b0000;
            operand <= 4'b0000;
            csn <= 1'b1;          // RAM not selected
            rwn <= 1'b1;          // Read mode
            alu_enable <= 1'b0;
        end else begin
            case(state)
                INIT: begin
                    state <= FETCH;
                    csn <= 1'b1;
                    rwn <= 1'b1;
                    alu_enable <= 1'b0;
                end
                
                FETCH: begin
                    // Fetch data from memory location specified by op1
                    state <= EXECUTE;
                    addr <= op1;
                    csn <= 1'b0;      // Select RAM
                    rwn <= 1'b1;      // Read mode
                    alu_enable <= 1'b0;
                end
                
                EXECUTE: begin
                    // Execute instruction using ALU
                    state <= STORE;
                    operand <= op2;
                    csn <= 1'b1;      // Deselect RAM during execute
                    alu_enable <= 1'b1;
                    
                    // Decode opcode and set ALU control signals
                    case(opcode)
                        3'b000: alu_sel <= 3'b000;  // STO (Transfer) - f = a (with b=0000, cin=0)
                        3'b001: alu_sel <= 3'b001;  // ADD - f = a + b
                        3'b010: alu_sel <= 3'b011;  // SUB - f = a + ~b + 1
                        3'b011: alu_sel <= 3'b110;  // AND - f = a & b
                        3'b100: alu_sel <= 3'b100;  // OR - f = a | b
                        3'b101: alu_sel <= 3'b101;  // XOR - f = a ^ b
                        3'b110: alu_sel <= 3'b111;  // NOT - f = ~a
                        default: alu_sel <= 3'b000;
                    endcase
                end
                
                STORE: begin
                    // Store result back to memory location op1
                    state <= FETCH;
                    addr <= op1;
                    csn <= 1'b0;      // Select RAM
                    rwn <= 1'b0;      // Write mode
                    alu_enable <= 1'b0;
                end
                
                default: state <= INIT;
            endcase
        end
    end
endmodule

