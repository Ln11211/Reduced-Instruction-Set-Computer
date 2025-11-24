`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2025 10:51:54 AM
// Design Name: 
// Module Name: gatestb
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


module gatestb;
reg a,b;
wire [5:0] y;
  
  //Units under test
  annd a1(y[0],a,b);  //modulename intant()
  
  oor o1(y[1],a,b);
  
  xoor x1(y[2],a,b);

  nannd n1(y[3],a,b);

  noor no1(y[4],a,b);
  
  noot not1(y[5],a);
  initial begin
    a=0;
    b=0;
    
    #5 a=1;
    b=0;
    
    #5 a=0;
    b=1;
  end
  //always #10 a=~a;
  //always #10 b=~b;
  initial #100 $stop;
endmodule
