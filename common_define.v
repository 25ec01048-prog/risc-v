`define INST_ADDR_SIZE 24
`define INST_SIZE 32
`define INST_MEM_SIZE 256  

`define REG_SIZE 32
`define REG_ADDR_SIZE 5
`define REGISTERS (1 << `REG_ADDR_SIZE)

`define reg_reg_op 0110011
`define reg_imm_alu_op 0010011
`define load_op  0000011
`define store_op 0100011
`define branch_op 1100011
`define LUI_op 0110111
`define AUIPIC_op  0010111
`define JAL_op 1101111
`define JALR_op 1100111

`define MEM_WORD_SIZE 32
`define MEM_ADDR_SIZE 12
`define MEMS 512

