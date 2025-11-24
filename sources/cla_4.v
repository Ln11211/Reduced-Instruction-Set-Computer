`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2025 12:40:57 PM
// Design Name: 
// Module Name: cla_4
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


module cla_4(sum,cout,cin_to_msb,a,b,cin);
    output [3:0] sum;
    output cout;
    output cin_to_msb;
    input [3:0] a;
    input [3:0] b;
    input cin;
    
    // the propagate and enerate equations, p=a^b and g=a.b
    wire [3:0] p= a^b;
    wire [3:0] g= a&b;
    
    //generating the carries ahead using the propagate and the generate signals
    wire c1 = g[0]|(p[0]&cin);
    wire c2 = g[1]|(p[1]&g[0])|(p[1]&p[0]&cin);
    wire c3 = g[2]|(p[2]&g[1])|(p[2]&p[1]&g[0])|(p[2]&p[1]&p[0]&cin);
    wire c4 = g[3]|(p[3]&g[2])|(p[3]&p[2]&g[1])|(p[3]&p[2]&p[1]&g[0])|(p[3]&p[2]&p[1]&p[0]&cin);
    
    assign sum={p[3]^c3,p[2]^c2,p[1]^c1,p[0]^cin};
    assign cout=c4;
    assign cin_to_msb=c3;
endmodule
