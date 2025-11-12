`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:40:16 11/11/2025
// Design Name:   ram_16x4_sync
// Module Name:   ram_16x4_sync_tb.v
// Project Name:  mindgrove
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ram_16x4_sync
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ram_16x4_sync_tb_v;
    reg clk, reset_n;
    reg [3:0] addr, datain;
    reg csn, rwn;
    wire [3:0] dataout;

    ram_16x4_sync uut (
        .clk(clk),
        .reset_n(reset_n),
        .addr(addr),
        .datain(datain),
        .csn(csn),
        .rwn(rwn),
        .dataout(dataout)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset_n = 0;
        addr = 0; datain = 0; csn = 1; rwn = 1;
        #10 reset_n = 1;

        // Write 1010 into address 0100
        addr = 4'b0100;
        datain = 4'b0101;
        csn = 0; rwn = 0;  // write mode
        @(posedge clk);    // perform write

        // Now read from address 0100
        rwn = 1;           // read mode
        @(posedge clk);
        $display("Read data from addr %b = %b", addr, dataout);
        #20 $finish;
    end
endmodule
