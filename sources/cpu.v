`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 12:23:26 PM
// Design Name: 
// Module Name: cpu
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


module cpu(
  input clk, input rst_n
);
  // Special regs
  wire [31:0] pc_curr, pc_next, sp_curr, sp_next;
  wire pc_we, sp_we;

 //PC module pc(curr,next,clk,rst,we);
  pc u_pc (.clk(clk), .rst(rst_n), .we(pc_we), .next(pc_next), .curr(pc_curr));
  //sp module sp(spcurr,clk,rst,we,spnext);
  sp u_sp (.clk(clk), .rst(rst_n), .we(sp_we), .spnext(sp_next), .spcurr(sp_curr));

  // CCR module ccr(fout,wen,clk,rst,fin);
  wire [3:0] CCR_in, CCR_out; wire ccr_we;
  ccr u_ccr(.clk(clk), .rst(rst_n), .wen(ccr_we), .fin(CCR_in), .fout(CCR_out));

  // Regfile
  //module regs16(data1,data2,clk,rst,raddr1,raddr2,waddr,wdata,wen);
  wire [3:0] rs1, rs2, rd; wire [31:0] rA, rB, rf_wdata; wire rf_we;
  regs16 u_rf(.clk(clk), .rst(rst_n), .raddr1(rs1), .raddr2(rs2), .data1(rA), .data2(rB),
                    .waddr(rd), .wdata(rf_wdata), .wen(rf_we));

  // ALU module alu(Y,N,Z,C,V,a,b,oper);
wire [3:0]  alu_op;
wire [31:0] alu_A, alu_B;
wire [31:0] alu_Y;
wire        alu_N, alu_Z, alu_C, alu_V;
wire [31:0] alu_Y_hi;   // optional; not required by controller

alu u_alu (
  .clk   (clk),
  .rst_n (rst_n),
  .a     (alu_A),
  .b     (alu_B),
  .oper  (alu_op),
  .Y     (alu_Y),
  .N     (alu_N),
  .Z     (alu_Z),
  .C     (alu_C),
  .V     (alu_V),
  .Y_hi  (alu_Y_hi)
);

  assign CCR_in = {alu_N, alu_Z, alu_C, alu_V};

  // Memories
  wire        imem_en, dmem_en, dmem_we;
  wire [31:0] imem_addr, imem_rdata, dmem_addr, dmem_wdata, dmem_rdata;

mem #(
  .WORDS(256),
  .INIT_EN(1),
  .INIT_FILE("prog.mem")
) u_imem (
  .clk(clk), .en(imem_en), .we(1'b0),
  .addr(imem_addr), .wdata(32'b0), .rdata(imem_rdata)
);

// Data memory: no preload
mem #(
  .WORDS(256),
  .INIT_EN(0),
  .INIT_FILE("")
) u_dmem (
  .clk(clk), .en(dmem_en), .we(dmem_we),
  .addr(dmem_addr), .wdata(dmem_wdata), .rdata(dmem_rdata)
);

  // Controller
  controller u_ctl(
    .clk(clk), .rst_n(rst_n),
    .imem_en(imem_en), .imem_addr(imem_addr), .imem_rdata(imem_rdata),
    .dmem_en(dmem_en), .dmem_we(dmem_we), .dmem_addr(dmem_addr), .dmem_wdata(dmem_wdata), .dmem_rdata(dmem_rdata),
    .rs1_idx(rs1), .rs2_idx(rs2), .rd_idx(rd), .reg_we(rf_we), .rf_wdata(rf_wdata), .rf_rdata1(rA), .rf_rdata2(rB),
    .alu_op(alu_op), .alu_A(alu_A), .alu_B(alu_B), .alu_Y(alu_Y),
    .alu_N(alu_N), .alu_Z(alu_Z), .alu_C(alu_C), .alu_V(alu_V),
    .ccr_we(ccr_we), .ccr_in(CCR_in), .ccr_out(CCR_out),
    .pc_we(pc_we), .pc_next(pc_next), .pc_curr(pc_curr),
    .sp_we(sp_we), .sp_next(sp_next), .sp_curr(sp_curr)
  );
endmodule
