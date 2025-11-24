`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 09:28:00 AM
// Design Name: 
// Module Name: mem
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


// mem.v  (Verilog-2001, works in Vivado)
`timescale 1ns/1ps

module mem #(
  parameter WORDS = 256,
  parameter INIT_EN  = 1'b0,
  parameter [8*128-1:0] INIT_FILE = ""  // string as packed array of bytes
)(
  input              clk,
  input              en,
  input              we,
  input      [31:0]  addr,   // byte address
  input      [31:0]  wdata,
  output reg [31:0]  rdata
);
  localparam AW = $clog2(WORDS);
  reg [31:0] ram [0:WORDS-1];

  // Word index (word-aligned)
  wire [AW-1:0] widx = addr[AW+1:2];

  // Optional preload for IMEM (simulation time)
  integer i;
  initial begin
  for (i = 0; i < WORDS; i = i + 1)
    ram[i] = 32'h0000_0000;
    
    if (INIT_EN) begin
      $display("IMEM: loading %0s (%0d words) at t=%0t", INIT_FILE, WORDS, $time);
      $readmemh(INIT_FILE, ram);
    end
  end

  always @(posedge clk) begin
    if (en) begin
      if (we) ram[widx] <= wdata; // write
      rdata <= ram[widx];         // synchronous read (valid next cycle)
    end
  end
  
endmodule

