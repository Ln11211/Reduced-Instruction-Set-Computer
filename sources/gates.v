module annd(output [31:0] y, input [31:0] a, input [31:0] b);
  assign y = a&b; 
endmodule
module oor(output [31:0] y, input [31:0] a, input [31:0] b);
  assign y = a|b;
endmodule
module xoor(output [31:0] y, input [31:0] a, input [31:0] b);  
  assign y = a^b;  
endmodule
module noot(output [31:0] y, input [31:0] a);  
  assign y = ~a;
endmodule
module nannd(output [31:0] y, input [31:0] a, input [31:0] b);
  assign y = ~(a&b);
endmodule
module noor(output [31:0] y, input [31:0] a, input [31:0] b);
  assign y = ~(a|b);
endmodule