`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2025 04:28:20 PM
// Design Name: 
// Module Name: alutb
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


module alutb;
reg [31:0] a;
reg [31:0] b;
reg [3:0] oper;

wire N,Z,C,V;
wire [31:0] Y;
alu alu_uut(Y,N,Z,C,V,a,b,oper);

initial begin
$display ("a = %d b=%d Y=%d", a,b,Y);
{a}=32'd550;
{b}=32'd600;
oper=4'd0; //add
#2
$display ("a = %d b=%d Y=%d", a,b,Y);

#100
{a}=32'd2;
{b}=32'd3;
oper=4'd1; //sub
#2
$display ("a = %d b=%d Y=%d", a,b,Y);

#100
{a}=32'd3;
{b}=32'd3;
oper=4'd2; //and
#2
$display ("a = %d b=%d Y=%d", a,b,Y);

#100
{a}=32'd3;
{b}=32'd3;
oper=4'd8; //==
#2
$display ("a = %d b=%d Y=%d", a,b,Y);

#100
{a}=-32'd3;
{b}=-32'd3;
oper=4'd10; //<=
#2
$display ("a = %d b=%d Y=%d", a,b,Y);

#100
{a}=-32'd3;
{b}=32'd5;
oper=4'd10; //<
#2
$display ("a = %d b=%d Y=%d", a,b,Y);

#100
{a}=-32'd5;
{b}=-32'd5;
oper=4'd11; //<=
#2
$display ("a = %d b=%d Y=%d", a,b,Y);

#100
{a}=-32'd3;
{b}=-32'd5;
oper=4'd13; //>
#2
$display ("a = %d b=%d Y=%d", a,b,Y);
end
endmodule
