`ifndef PARAMETERS_VH
`define PARAMETERS_VH

//RV32I Architecture Parameters

// Width definitions
`define DATA_WIDTH 32   // Data width in bits
`define ADDR_WIDTH 32   // Address width in bits
`define INST_WIDTH 32  // Instruction width in bits
`define NUM_REGISTER 32 // Number of registers (5 bits to address 32 registers)

// Memory size
`define MEM_SIZE (1 << `ADDR_WIDTH) // Total number of memory locations

`define FUNCT_7 7
`define FUNCT_3 3

// RISC-V Base Instruction Set Opcodes
`define OPCODE 7
`define OP_LUI     7'b0110111 // Load Upper Immediate 
`define OP_AUIPC   7'b0010111 // Add Upper Immediate to PC 
`define OP_JAL     7'b1101111 // Jump and Link
`define OP_JALR    7'b1100111 // Jump and Link Register I Type
`define OP_BRANCH  7'b1100011 // Branch Instructions (BEQ, BNE, BLT, etc.)
`define OP_LOAD    7'b0000011 // Load Instructions (LB, LH, LW, LBU, LHU)
`define OP_STORE   7'b0100011 // Store Instructions (SB, SH, SW)
`define OP_ALU     7'b0110011 // ALU Instructions (ADD, SUB, AND, OR, XOR, etc.)
`define OP_ALUI    7'b0010011 // ALU Immediate Instructions (ADDI, ANDI, ORI, XORI, etc.) I Type
`define OP_FENCE   7'b0001111 // Fence
`define OP_SYSTEM  7'b1110011 // System Instructions (ECALL, EBREAK, etc.) I Type

// RISC-V ALU Operations [FUNCT_7b5, FUNCT_3(2:0)] R Type
//`define ALU_NOP    10'b0000000000 // No Operation (Placeholder)
`define ALU_ADD    4'b0000 // Add
`define ALU_SUB    4'b1000 // Subtract
`define ALU_AND    4'b0111 // Bitwise AND
`define ALU_OR     4'b0110 // Bitwise OR
`define ALU_XOR    4'b0100 // Bitwise XOR
`define ALU_SLT    4'b0010 // Set Less Than (signed)
`define ALU_SLTU   4'b0011 // Set Less Than (unsigned)
`define ALU_SLL    4'b0001 // Shift Left Logical
`define ALU_SRL    4'b0101 // Shift Right Logical
`define ALU_SRA    4'b1101 // Shift Right Arithmetic

// RISC-V ALUI Operations [FUNCT_3(2:0)] I Type 
`define ALU_ADDI    3'b000 // Add Immediate
`define ALU_ANDI    3'b111 // Bitwise AND Immediate
`define ALU_ORI     3'b110 // Bitwise OR Immediate
`define ALU_XORI    3'b100 // Bitwise XOR Immediate
`define ALU_SLTI    3'b010 // Set Less Than (signed) Immediate
`define ALU_SLTIU   3'b011 // Set Less Than (unsigned) Immediate
`define ALU_SLLI    3'b001 // Shift Left Logical Immediate (IMM 11:5])
`define ALU_SRLI    3'b101 // Shift Right Logical Immediate
`define ALU_SRAI    3'b101 // Shift Right Arithmetic Immediate (IMM 11:5])

// RISC-V Load Operations [FUNCT_3(2:0)] I Type
`define LOAD_LB     3'b000 // Load Byte
`define LOAD_LH     3'b001 // Load Halfword
`define LOAD_LW     3'b010 // Load Word
`define LOAD_LBU    3'b100 // Load Byte Unsigned
`define LOAD_LHU    3'b101 // Load Halfword Unsigned

// RISC-V Store Operations [FUNCT_3(2:0)] S Type
`define STORE_SB    3'b000 // Store Byte
`define STORE_SH    3'b001 // Store Halfword
`define STORE_SW    3'b010 // Store Word

// RISC-V Branch Operations [FUNCT_3(2:0)] B Type
`define BRANCH_BEQ    3'b000 // Branch Equal
`define BRANCH_BNE    3'b001 // Branch Not Equal
`define BRANCH_BLT    3'b100 // Branch Less Than
`define BRANCH_BGE    3'b101 // Branch Greater Than Or Equal
`define BRANCH_BLTU   3'b110 // Branch Less Than Unsigned
`define BRANCH_BGEU   3'b111 // Branch Greater Than Or Equal Unsigned

`define BRANCH_JAL_JALR 3'b010

// Other constants or parameters can be defined here

`endif