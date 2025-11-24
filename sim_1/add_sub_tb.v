`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2025 04:14:14 PM
// Design Name: 
// Module Name: add_sub_tb
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


module add_sub_tb;
  reg  [31:0] a;
  reg  [31:0] b;
  wire [31:0] sum;
  reg  op;  //if op is 0 then add else subtract
  
  //couple of flags, Carry, Overflow, Negative and Zero
  wire C;
  wire V;
  wire N;
  wire Z;
  
  add_sub_logic uut(sum,C,V,N,Z,a,b,op);
  
  initial begin
  a=32'hFFFF_FFFF;
  b=32'h0000_0001;
  op=0;
  
  #100
  a=32'h7FFF_FFFF;
  b=32'h0000_0001;
  op=0;
  
  #100
  a=32'h0000_0000;
  b=32'h0000_0001;
  op=1;
  
  #100
  a=32'h8000_0000;
  b=32'h7FFF_FFFF;
  op=0;
  end
  initial #400 $stop;
endmodule
