`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2025 01:07:35 PM
// Design Name: 
// Module Name: cla4tb
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


module cla4tb;

reg [3:0] a;
reg [3:0] b;
reg cin;

wire [3:0] sum;
wire cout;

cla_4 uut(sum,cout,a,b,cin);

initial begin
    a = $random%16;
    b = $random%16;
    cin = $random%2;
    
    #100
    a = $random%16;
    b = $random%16;
    cin = $random%2;
end
endmodule
