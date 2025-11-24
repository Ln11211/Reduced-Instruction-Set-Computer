`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2025 04:13:25 PM
// Design Name: 
// Module Name: sp
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


module sp(spcurr,clk,rst,we,spnext);
output [31:0] spcurr;
input clk,rst,we;
input [31:0] spnext;

reg [31:0] q;

always @(posedge clk or negedge rst) begin
    if (!rst) q<=32'b0;
    else if(we) q<=spnext;
end

assign spcurr=q;
endmodule
