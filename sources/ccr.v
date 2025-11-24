`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2025 04:44:02 PM
// Design Name: 
// Module Name: ccr
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
module ccr(fout,wen,clk,rst,fin);
output [3:0] fout;
input wen,clk,rst;
input [3:0] fin;
reg [3:0] flag;

always @(posedge clk or negedge rst) begin
    if(!rst)begin
        flag<=4'b0;
    end
    else if(wen) begin
        flag<=fin;
        end
end
assign fout = flag;
endmodule
