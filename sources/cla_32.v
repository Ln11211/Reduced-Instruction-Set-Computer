`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2025 02:22:15 PM
// Design Name: 
// Module Name: cla_32
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


module cla_32(sum,cout,cin_to_msb,a,b,cin);
input [31:0]a;
input [31:0] b;
input cin;

output [31:0] sum;
output cout;
output cin_to_msb;

wire [7:0] c_in_msbs;
wire [8:0] c;
assign c[0]=cin;

genvar i;
generate
    for(i=0;i<8;i=i+1)begin
    cla_4 cla(sum[4*i+3:4*i],c[i+1],c_in_msbs[i],a[4*i+3:4*i],b[4*i+3:4*i],c[i]);
    end
endgenerate
assign cout=c[8];
assign cin_to_msb=c_in_msbs[7];
endmodule
