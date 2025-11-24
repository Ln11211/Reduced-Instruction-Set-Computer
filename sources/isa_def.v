`ifndef isa_def
`define isa_def

// Opcodes [31:26]
`define OPC_ALUR  6'h00
`define OPC_ALUI  6'h01
`define OPC_LD    6'h02
`define OPC_ST    6'h03
`define OPC_BR    6'h04
`define OPC_CALL  6'h05
`define OPC_RET   6'h06
`define OPC_LDI   6'h07

// R-type funct [13:10]
`define FUN_ADD   4'h0
`define FUN_SUB   4'h1
`define FUN_AND   4'h2
`define FUN_OR    4'h3
`define FUN_XOR   4'h4
`define FUN_NOT   4'h5
`define FUN_CMP   4'h6
`define FUN_MUL   4'h7

// Internal ALU op (match your alu.v)
`define ALU_ADD   4'd0
`define ALU_SUB   4'd1
`define ALU_AND   4'd2
`define ALU_OR    4'd3
`define ALU_XOR   4'd4
`define ALU_NOT   4'd5
`define ALU_CMP   4'd6
`define ALU_MUL   4'd7

// Branch cond [25:22]
`define BC_AL     4'h0
`define BC_EQ     4'h1
`define BC_NE     4'h2
`define BC_LT     4'h3
`define BC_LE     4'h4
`define BC_GT     4'h5
`define BC_GE     4'h6
`define BC_CS     4'h7
`define BC_CC     4'h8

`endif
