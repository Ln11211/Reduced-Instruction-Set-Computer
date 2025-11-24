`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 09:23:49 AM
// Design Name: 
// Module Name: branch_cond
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


// ===== branch_cond.v =====
`include "isa_def.v"

module branch_cond (
  input  [3:0] cond,    // [25:22] from instr
  input  [3:0] CCR,     // {N,Z,C,V}
  output       take
);
  wire N = CCR[3], Z = CCR[2], C = CCR[1], V = CCR[0]; // or your bit order; adjust

  wire s_less = N ^ V;       // signed less-than from CMP
  wire s_le   = Z | s_less;

  reg t;
  always @* begin
      case (cond)
      `BC_AL: t = 1'b1;
      `BC_EQ: t =  Z;
      `BC_NE: t = ~Z;
      `BC_LT: t =  s_less;
      `BC_LE: t =  s_le;
      `BC_GT: t = ~s_le;
      `BC_GE: t = ~s_less;
      `BC_CS: t =  C;     // unsigned: carry set == no-borrow
      `BC_CC: t = ~C;     // unsigned: carry clear == borrow
      default: t = 1'b0;
    endcase
  end
  assign take = t;
endmodule

