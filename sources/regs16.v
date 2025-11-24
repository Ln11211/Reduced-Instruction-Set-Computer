`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2025 10:11:16 PM
// Design Name: 
// Module Name: regs16
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


module regs16(data1,data2,clk,rst,raddr1,raddr2,waddr,wdata,wen);
output reg [31:0] data1;
output reg [31:0] data2;
input clk,rst,wen;
input [3:0] raddr1;
input [3:0] raddr2;
input [3:0] waddr;
input [31:0] wdata;

reg [31:0] r [15:0];

//reseting the registers when the reset is 0, it is active low reset
integer i;
always @(negedge rst) begin
    for(i=0;i<16;i=i+1) begin
        r[i]<=32'b0;
    end
end

//writing using the single write port, the write operation is synchronous so is at poesitive edge of the clock
always @(posedge clk) begin
    if(wen) begin 
        r[waddr]<=wdata;
        $display("RF: R[%0d] <= %08h", waddr, wdata);
    end
end

//reading using the two read ports, the read operation is asynchronous 
always @(*) begin
//    if (wen && raddr1 == waddr) begin
//        data1=wdata;
//    end
//    else data1=r[raddr1];
    
//    if (wen && raddr2 == waddr) begin
//        data2=wdata;
//    end
//    else data2=r[raddr2];
    data1 = r[raddr1];
    data2 = r[raddr2];
end
endmodule
