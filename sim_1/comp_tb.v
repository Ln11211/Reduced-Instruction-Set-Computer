`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2025 01:07:07 PM
// Design Name: 
// Module Name: comp_tb
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


module comp_tb;
reg [31:0] a;
reg [31:0] b;
reg [2:0] oper;

wire val;
comparator uut(val,a,b,oper);

initial begin
{a}=32'd2;
{b}=32'd3;
oper=3'b000;  //==test

#100
{a}=32'd2;
{b}=32'd3;
oper=3'b001; //!= test

#100
{a}=32'd2;
{b}=32'd3;
oper=3'b010; //< test

#100
{a}=32'd3;
{b}=32'd3;
oper=3'b011; //<= test 

#100
{a}=32'd2;
{b}=32'd3;
oper=3'b100; //> test

#100
{a}=32'd3;
{b}=32'd3;
oper=3'b101; //>=test

#100
{a}=32'd2;
{b}=-32'd3;
oper=3'b010; //<test  negative

#100
{a}=-32'd2;
{b}=-32'd3;
oper=3'b100; //>test  negative

#100
{a}=-32'd2;
{b}=-32'd2;
oper=3'b000; // == negative
end
endmodule
