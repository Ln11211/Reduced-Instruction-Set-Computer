`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2025 03:56:36 PM
// Design Name: 
// Module Name: add_sub_logic
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


module add_sub_logic(sum,C,V,N,Z,a,b,op);
  input  [31:0] a;
  input  [31:0] b;
  output [31:0] sum;
  input  op;  //if op is 0 then add else subtract
  
  //couple of flags, Carry, Overflow, Negative and Zero respectively
  output C;
  output V;
  output N;
  output Z;
    
  wire [31:0] bdash = b ^ {32{op}}; //will do invertion of B using xor invert, LN remember this!!!!
  wire cin = op;
  wire cin_to_msb;
  wire cout;

  cla_32 adder_sub(sum,cout,cin_to_msb,a,bdash,cin);
  assign V= cout^cin_to_msb;
  assign N= sum[31];
  assign Z= ~(|sum);
  assign C= op ? ~cout : cout;

endmodule