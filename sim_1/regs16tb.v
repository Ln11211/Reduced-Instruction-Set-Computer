`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2025 10:56:51 PM
// Design Name: 
// Module Name: regs16tb
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


module regs16tb;
wire [31:0] data1;
wire [31:0] data2;
reg clk,rst,wen;
reg [3:0] raddr1;
reg [3:0] raddr2;
reg [3:0] waddr;
reg [31:0] wdata;

regs16 regs(data1,data2,clk,rst,raddr1,raddr2,waddr,wdata,wen); 

integer i;
//LN remember !!!!! you don't have a common clock yet !!!!
initial begin
    clk = 1; //to toggle clk at alternate cycles
    rst = 1;
//53 41 4E 4A 41 4E 41
//6D 65 6F 77 20 6D 65 6F 77

    wen=1; //when en is high, write the data
    waddr=4'd0;
    wdata=32'h0000_006D;
    raddr2=waddr;
    #0.5 wen=0;
    
    #1.5 wen=1;
    waddr=4'd1;
    wdata=32'h0000_0065;
    raddr2=waddr;
    # 0.5 wen=0;
    
    #1.5 wen=1;
    waddr=4'd2;
    wdata=32'h0000_006F;
    raddr2=waddr;
    #0.5 wen=0;

    #1.5 wen=1;
    waddr=4'd3;
    wdata=32'h0000_0077;
    raddr2=waddr;
    #0.5 wen=0;
    
    #1.5 wen=1;
    waddr=4'd4;
    wdata=32'h0000_0020;
    raddr2=waddr;
    #0.5 wen=0;
    
    #1.5 wen=1;
    waddr=4'd5;
    wdata=32'h0000_006D;
    raddr2=waddr;
    #0.5 wen=0;

    #1.5 wen=1;
    waddr=4'd6;
    wdata=32'h0000_0065;
    raddr2=waddr;
    #0.5 wen=0;

    #1.5 wen=1;
    waddr=4'd7;
    wdata=32'h0000_006F;
    raddr2=waddr;
    #0.5 wen=0;
    
    #1.5 wen=1;
    waddr=4'd8;
    wdata=32'h0000_0077;
    raddr2=waddr;
    #0.5 wen=0;
    
    $display("The data stored in memory from address 0x0 to 0x8 is:");
    
    for(i=0;i<9;i=i+1) begin
        raddr1=i;
        #1 $write("%h ",data1);
    end
    $display();
    for(i=0;i<9;i=i+1) begin
        raddr1=i;
        #1 $write("%s",data1);
    end
end
always #1 clk=~clk;
initial #36 $stop;
endmodule
