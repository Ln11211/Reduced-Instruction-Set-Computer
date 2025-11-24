`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2025 03:16:26 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies:
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "isa_def.v"

module alu(
  input         clk,
  input         rst_n,
  input  [31:0] a,
  input  [31:0] b,
  input  [3:0]  oper,

  output reg [31:0] Y,
  output            N,
  output            Z,
  output            C,
  output            V,
  output      [31:0] Y_hi
);

  // ---------- add/sub instantiation ----------
  wire [31:0] sum;
  wire C_add, V_add, N_add, Z_add;
  wire is_sub_or_cmp = (oper == `ALU_SUB) || (oper == `ALU_CMP);

  add_sub_logic u_addsub (
    .sum (sum),
    .C   (C_add),
    .V   (V_add),
    .N   (N_add),
    .Z   (Z_add),
    .a   (a),
    .b   (b),
    .op  (is_sub_or_cmp)   // 0=ADD, 1=SUB
  );

  // ---------- logic ops ----------
  wire [31:0] andout = a & b;
  wire [31:0] orout  = a | b;
  wire [31:0] xorout = a ^ b;
  wire [31:0] notout = ~a;

  wire [63:0] prod64 = a * b;        
  assign Y_hi = prod64[63:32];

  // Flags for MUL
  wire        Z_mul = (prod64 == 64'd0);
  wire        N_mul = prod64[31];
  wire        C_mul = |prod64[63:32];              
  wire        V_mul = (prod64[63:32] != {32{prod64[31]}});

  // ---------- flags mux ----------
  reg N_r, Z_r, C_r, V_r;

  always @(*) begin
    // safe defaults
    Y   = 32'b0;
    N_r = 1'b0;
    Z_r = 1'b0;
    C_r = 1'b0;
    V_r = 1'b0;

    case (oper)
      `ALU_ADD: begin
        Y = sum;  N_r=N_add; Z_r=Z_add; C_r=C_add; V_r=V_add;
      end
      `ALU_SUB: begin
        Y = sum;  N_r=N_add; Z_r=Z_add; C_r=C_add; V_r=V_add;
      end
      `ALU_AND: begin
        Y = andout; N_r=Y[31]; Z_r=(Y==32'b0); C_r=1'b0; V_r=1'b0;
      end
      `ALU_OR : begin
        Y = orout;  N_r=Y[31]; Z_r=(Y==32'b0); C_r=1'b0; V_r=1'b0;
      end
      `ALU_XOR: begin
        Y = xorout; N_r=Y[31]; Z_r=(Y==32'b0); C_r=1'b0; V_r=1'b0;
      end
      `ALU_NOT: begin
        Y = notout; N_r=Y[31]; Z_r=(Y==32'b0); C_r=1'b0; V_r=1'b0;
      end
      `ALU_CMP: begin
        Y = 32'b0;  N_r=N_add; Z_r=Z_add; C_r=C_add; V_r=V_add; // result ignored by regfile
      end
      `ALU_MUL: begin
        Y = prod64[31:0];
        N_r=N_mul; Z_r=Z_mul; C_r=C_mul; V_r=V_mul;
      end
      default: begin
        // keep defaults
      end
    endcase
  end

  assign N = N_r;
  assign Z = Z_r;
  assign C = C_r;
  assign V = V_r;

endmodule