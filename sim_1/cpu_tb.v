`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2025 11:59:16 AM
// Design Name: 
// Module Name: cpu_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_cpu;
  reg clk = 0; always #5 clk = ~clk;
  reg rst_n = 0;

  cpu dut(.clk(clk), .rst_n(rst_n));

  initial begin
    rst_n = 0;
    repeat (4) @(posedge clk);
    rst_n = 1;

    // Run a bounded number of cycles
    repeat (400) @(posedge clk);
    $finish;
  end
  

endmodule


