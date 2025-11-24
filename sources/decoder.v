`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 07:53:25 AM
// Design Name: 
// Module Name: decoder
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

module decoder (
  input  [31:0] instr,

  output [5:0]  opc,
  output [3:0]  rd,
  output [3:0]  rs1,
  output [3:0]  rs2,
  output [3:0]  cond,
  output [3:0]  rx,
  output [31:0] imm32,

  output [3:0]  alu_op,
  output        use_imm,
  output        reg_we,
  output        ccr_we,
  output        mem_en,
  output        mem_we,
  output        is_load,
  output        pc_update_is_branch,
  output        is_call,
  output        is_ret
);

  wire [17:0] imm18  = instr[17:0];
  wire [1:0]  subop  = imm18[17:16];
  wire [15:0] imm16  = imm18[15:0];
  wire [31:0] imm16_se = {{16{imm16[15]}}, imm16};
  wire [31:0] imm16_ze = {16'h0000, imm16};

  assign opc  = instr[31:26];
  assign rd   = instr[25:22];
  assign rs1  = instr[21:18];
  assign rs2 = (opc == `OPC_ST) ? instr[25:22] : instr[17:14];

  assign cond = instr[25:22];
  assign rx   = instr[21:18];

  reg [3:0]  r_alu_op;
  reg        r_use_imm, r_reg_we, r_ccr_we, r_mem_en, r_mem_we;
  reg        r_is_load, r_pc_branch, r_is_call, r_is_ret;
  reg [31:0] r_imm32;

  always @(*) begin
    r_alu_op    = `ALU_ADD;
    r_use_imm   = 1'b0;
    r_reg_we    = 1'b0;
    r_ccr_we    = 1'b0;
    r_mem_en    = 1'b0;
    r_mem_we    = 1'b0;
    r_is_load   = 1'b0;
    r_pc_branch = 1'b0;
    r_is_call   = 1'b0;
    r_is_ret    = 1'b0;
    r_imm32     = 32'h0000_0000;

    case (opc)
      // ---------- R-type ----------
      `OPC_ALUR: begin
        $display("OPC decoded as ALUR at t=%0t", $time);
        case (instr[13:10])
          `FUN_ADD: begin r_alu_op=`ALU_ADD; r_reg_we=1'b1; r_ccr_we=1'b1; $display("  FUN_ADD"); end
          `FUN_SUB: begin r_alu_op=`ALU_SUB; r_reg_we=1'b1; r_ccr_we=1'b1; $display("  FUN_SUB"); end
          `FUN_AND: begin r_alu_op=`ALU_AND; r_reg_we=1'b1; r_ccr_we=1'b1; $display("  FUN_AND"); end
          `FUN_OR : begin r_alu_op=`ALU_OR ; r_reg_we=1'b1; r_ccr_we=1'b1; $display("  FUN_OR"); end
          `FUN_XOR: begin r_alu_op=`ALU_XOR; r_reg_we=1'b1; r_ccr_we=1'b1; $display("  FUN_XOR"); end
          `FUN_NOT: begin r_alu_op=`ALU_NOT; r_reg_we=1'b1; r_ccr_we=1'b1; $display("  FUN_NOT"); end
          `FUN_CMP: begin r_alu_op=`ALU_CMP; r_reg_we=1'b0; r_ccr_we=1'b1; $display("  FUN_CMP"); end
          `FUN_MUL: begin r_alu_op=`ALU_MUL; r_reg_we=1'b1; r_ccr_we=1'b1; $display("  FUN_MUL"); end
          default : $display("  FUN_??? %0d", instr[13:10]);
        endcase
      end

      // ---------- ALU immediates ----------
      `OPC_ALUI: begin
        $display("OPC decoded as ALUI at t=%0t", $time);
        r_use_imm = 1'b1;
        r_mem_en  = 1'b0;  // <- explicit
        r_mem_we  = 1'b0;  // <- explicit
        case (subop)
          2'b00: begin
            if (rd==4'h0) begin
              r_alu_op=`ALU_CMP; r_reg_we=1'b0;
              $display("  CMPI rd=0, rs1=%0d, imm=%0d", rs1, imm16_se);
            end else begin
              r_alu_op=`ALU_ADD; r_reg_we=1'b1;
              $display("  ADDI rd=%0d, rs1=%0d, imm=%0d", rd, rs1, imm16_se);
            end
            r_imm32=imm16_se; r_ccr_we=1'b1;
          end
          2'b01: begin r_alu_op=`ALU_AND; r_imm32=imm16_ze; r_reg_we=1'b1; r_ccr_we=1'b1; $display("  ANDI rd=%0d, rs1=%0d, imm=%0h", rd, rs1, imm16_ze); end
          2'b10: begin r_alu_op=`ALU_OR ; r_imm32=imm16_ze; r_reg_we=1'b1; r_ccr_we=1'b1; $display("  ORI  rd=%0d, rs1=%0d, imm=%0h", rd, rs1, imm16_ze); end
          2'b11: begin r_alu_op=`ALU_XOR; r_imm32=imm16_ze; r_reg_we=1'b1; r_ccr_we=1'b1; $display("  XORI rd=%0d, rs1=%0d, imm=%0h", rd, rs1, imm16_ze); end
        endcase
      end

      // ---------- LDI ----------
      `OPC_LDI: begin
        $display("OPC decoded as LDI at t=%0t", $time);
        r_use_imm = 1'b1;
        r_alu_op  = `ALU_ADD;
        r_imm32   = {{14{imm18[17]}}, imm18};
        r_reg_we  = 1'b1;
        r_ccr_we  = 1'b1;
      end

      // ---------- LD ----------
      `OPC_LD: begin
        $display("OPC decoded as LD at t=%0t", $time);
        r_use_imm = 1'b1; r_alu_op=`ALU_ADD; r_imm32=imm16_se;
        r_mem_en=1'b1; r_mem_we=1'b0; r_is_load=1'b1;
      end

      // ---------- ST ----------
      `OPC_ST: begin
        $display("OPC decoded as ST at t=%0t", $time);
        r_use_imm=1'b1; r_alu_op=`ALU_ADD; r_imm32=imm16_se;
        r_mem_en=1'b1; r_mem_we=1'b1;
      end

      // ---------- Control flow ----------
      `OPC_BR  : begin r_pc_branch=1'b1; $display("OPC decoded as BR at t=%0t", $time); end
      `OPC_CALL: begin r_is_call  =1'b1; $display("OPC decoded as CALL at t=%0t", $time); end
      `OPC_RET : begin r_is_ret   =1'b1; $display("OPC decoded as RET at t=%0t", $time); end
    endcase
  end

  assign alu_op              = r_alu_op;
  assign use_imm             = r_use_imm;
  assign reg_we              = r_reg_we;
  assign ccr_we              = r_ccr_we;
  assign mem_en              = r_mem_en;
  assign mem_we              = r_mem_we;
  assign is_load             = r_is_load;
  assign pc_update_is_branch = r_pc_branch;
  assign is_call             = r_is_call;
  assign is_ret              = r_is_ret;
  assign imm32               = r_imm32;
  
endmodule


