`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 11:59:29 AM
// Design Name: 
// Module Name: control
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
`include "isa_def.v"

module controller(
  input              clk,
  input              rst_n,

  // instr mem (sync read)
  output             imem_en,
  output     [31:0]  imem_addr,
  input      [31:0]  imem_rdata,

  // data mem
  output reg         dmem_en,
  output reg         dmem_we,
  output reg [31:0]  dmem_addr,
  output reg [31:0]  dmem_wdata,
  input      [31:0]  dmem_rdata,

  // regfile
  output     [3:0]   rs1_idx,
  output     [3:0]   rs2_idx,
  output reg [3:0]   rd_idx,
  output reg         reg_we,
  output reg [31:0]  rf_wdata,
  input      [31:0]  rf_rdata1,
  input      [31:0]  rf_rdata2,

  // ALU
  output reg  [3:0]  alu_op,
  output reg [31:0]  alu_A,
  output reg [31:0]  alu_B,
  input      [31:0]  alu_Y,
  input              alu_N, alu_Z, alu_C, alu_V,

  // CCR
  output reg         ccr_we,
  output     [3:0]   ccr_in,
  input      [3:0]   ccr_out,

  // PC/SP
  output reg         pc_we,
  output reg [31:0]  pc_next,
  input      [31:0]  pc_curr,

  output reg         sp_we,
  output reg [31:0]  sp_next,
  input      [31:0]  sp_curr
);

  // ---------------- Fetch path ----------------
  assign imem_en   = 1'b1;
  assign imem_addr = pc_curr;

  // Instr register (IMEM is synchronous)
  reg [31:0] instr_q;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) instr_q <= 32'b0;
    else        instr_q <= imem_rdata;
  end

  // -------------- Decode ---------------------
  wire [5:0]  opc;
  wire [3:0]  rd, rs1, rs2, cond, rx;
  wire [31:0] imm32;
  wire [3:0]  dec_alu_op;
  wire        use_imm, dec_reg_we, dec_ccr_we, dec_mem_en, dec_mem_we;
  wire        is_load, pc_is_branch, is_call, is_ret;

  decoder u_dec(
    .instr(instr_q),
    .opc(opc), .rd(rd), .rs1(rs1), .rs2(rs2), .cond(cond), .rx(rx), .imm32(imm32),
    .alu_op(dec_alu_op), .use_imm(use_imm), .reg_we(dec_reg_we), .ccr_we(dec_ccr_we),
    .mem_en(dec_mem_en), .mem_we(dec_mem_we), .is_load(is_load),
    .pc_update_is_branch(pc_is_branch), .is_call(is_call), .is_ret(is_ret)
  );

  assign rs1_idx = rs1;               // BR/CALL use rs1==rx by format
  assign rs2_idx = rs2;

  // CCR input (bit order = {N,Z,C,V})
  assign ccr_in = {alu_N, alu_Z, alu_C, alu_V};

  // -------------- Branch cond ----------------
  wire branch_take;
  branch_cond u_bc(.cond(cond), .CCR(ccr_out), .take(branch_take));

  // -------------- FSM ------------------------
  reg [2:0] st, st_n;
  localparam S_EXEC  = 3'd0,
             S_MEMRD = 3'd1,
             S_WB    = 3'd2,
             S_BR    = 3'd3,
             S_CALL1 = 3'd4,
             S_CALL2 = 3'd5,
             S_RET1  = 3'd6,
             S_RET2  = 3'd7;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) st <= S_EXEC;
    else        st <= st_n;
  end

  // -------- Latches for LOAD writeback (kept) --------
  reg [31:0] ld_addr_q;
  reg [3:0]  ld_rd_q;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ld_addr_q <= 32'd0;
      ld_rd_q   <= 4'd0;
    end else if (st == S_EXEC && is_load) begin
      ld_addr_q <= alu_Y; // effective address computed for the LD in S_EXEC
      ld_rd_q   <= rd;    // destination register of the LD
    end
  end

  // Handy predicate
  wire is_simple_alu = (~dec_mem_en && ~pc_is_branch && ~is_call && ~is_ret);
  // (MUL is now single-cycle → part of simple_alu)

  // -------------- Control --------------
  always @(*) begin
    // ---- defaults (NOP) ----
    rd_idx   = rd;

    // ALU
    alu_op    = dec_alu_op;
    alu_A     = rf_rdata1;
    alu_B     = use_imm ? imm32 : rf_rdata2;

    // Regfile / CCR
    reg_we    = 1'b0;
    rf_wdata  = alu_Y;
    ccr_we    = dec_ccr_we;       // single-cycle: flags valid now

    // Data mem
    dmem_en   = 1'b0;
    dmem_we   = 1'b0;
    dmem_addr = alu_Y;            // addr = rs1 + imm
    dmem_wdata= rf_rdata2;

    // PC / SP
    pc_we     = 1'b1;
    pc_next   = pc_curr + 32'd4;
    sp_we     = 1'b0;
    sp_next   = sp_curr;

    // ---- next-state default ----
    st_n      = S_EXEC;

    // ---- state behavior ----
    case (st)
      // ======================================================
      S_EXEC: begin
        // ALUR/ALUI/LDI that write result this cycle (MUL included)
        if (is_simple_alu) begin
          reg_we = dec_reg_we;
        end

        // store
        if (dec_mem_en && dec_mem_we) begin
          dmem_en = 1'b1; dmem_we = 1'b1;
        end

        // multi-cycle only for LOAD and control flow
        if (is_load)            st_n = S_MEMRD;
        else if (pc_is_branch)  st_n = S_BR;
        else if (is_call)       st_n = S_CALL1;
        else if (is_ret)        st_n = S_RET1;
        else                    st_n = S_EXEC;
      end

      // ======================================================
      S_MEMRD: begin
        dmem_en   = 1'b1; dmem_we = 1'b0;
        dmem_addr = ld_addr_q;
        st_n      = S_WB;
      end

      S_WB: begin
        reg_we    = 1'b1;
        rf_wdata  = dmem_rdata;
        rd_idx    = ld_rd_q;
        st_n      = S_EXEC;
      end

      // ======================================================
      S_BR: begin
        pc_we   = 1'b1;
        pc_next = branch_take ? rf_rdata1 : (pc_curr + 32'd4);
        st_n    = S_EXEC;
      end

      // ======================================================
      S_CALL1: begin
        dmem_en   = 1'b1; dmem_we = 1'b1;
        dmem_addr = sp_curr - 32'd4;
        dmem_wdata= pc_curr + 32'd4;
        sp_we     = 1'b1; sp_next = sp_curr - 32'd4;
        st_n      = S_CALL2;
      end

      S_CALL2: begin
        pc_we   = 1'b1;
        pc_next = rf_rdata1;
        st_n    = S_EXEC;
      end

      // ======================================================
      S_RET1: begin
        dmem_en   = 1'b1; dmem_we = 1'b0;
        dmem_addr = sp_curr;
        st_n      = S_RET2;
      end

      S_RET2: begin
        pc_we   = 1'b1;
        pc_next = dmem_rdata;
        sp_we   = 1'b1; sp_next = sp_curr + 32'd4;
        st_n    = S_EXEC;
      end

      default: begin
        st_n = S_EXEC;
      end
    endcase
  end

endmodule


