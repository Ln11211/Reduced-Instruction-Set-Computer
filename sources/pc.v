`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2025 12:02:31 AM
// Design Name: 
// Module Name: pc
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


module pc(curr,next,clk,rst,we);
output [31:0] curr;
input [31:0] next;
input clk,rst,we;

reg [31:0] q;
always @(posedge clk or negedge rst) begin
if (!rst) begin
    q <= 32'b0;
end
    else if(we) begin 
    q <= next;
end
end
assign curr=q;
endmodule
