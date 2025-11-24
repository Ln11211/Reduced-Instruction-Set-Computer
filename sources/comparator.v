`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2025 11:30:27 PM
// Design Name: 
// Module Name: comparator
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


module comparator(val,a,b,oper);
output reg val;
input [31:0] a;
input [31:0] b;
input [2:0] oper;

wire [31:0] res;
wire C,V,N,Z;
wire op = 1;

add_sub_logic sub(res,C,V,N,Z,a,b,op);
/*  000 is ==  001 is != 
    010 is < 011 is <= 
    100 is > 101 is >= 
*/
always @(oper) begin
case(oper)
    3'b000: val= Z;
    3'b001: val= ~Z;
    3'b010: val= N;
    3'b011: val= N||Z;
    3'b100: val= ~N;
    3'b101: val= (~N)||Z;
endcase
end
endmodule