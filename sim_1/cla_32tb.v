`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2025 04:23:14 PM
// Design Name: 
// Module Name: cla_32tb
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


module cla_32tb;
wire cout;
wire [31:0] sum;
reg [31:0] a;
reg [31:0] b;
reg cin;

cla_32 uut(sum,cout,a,b,cin);
initial begin

    a=$random%(2^^32);
    b=$random%(2^^32);
    cin=$random%2;
    
    //Testing for no addition, no carry, just empty
    #100
    a=32'h0000_0000;
    b=32'h0000_0000;
    cin=0;
    
    //testing for all 1 in opA and one 1 in opB, no carry in, there should be a carry out
    #100
    a=32'hFFFF_FFFF;
    b=32'h0000_0001;
    cin=0;
    
    //testing for all 1 in opA and all 0 in opB, no carry in, ther should be no carry out
    #100
    a=32'hFFFF_FFFF;
    b=32'h0000_0000;
    cin=0;

    //testing for overflow in sum
    #100
    a=32'h7FFF_FFFF;
    b=32'h0000_0001;
    cin=0;
end
endmodule