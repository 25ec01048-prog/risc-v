`define INST_ADDR_SIZE 4
`define INST_SIZE 32
`define INST_MEM_SIZE (1 << `INST_ADDR_SIZE)

`define REG_SIZE 32
`define REG_ADDR_SIZE 5
`define REGISTERS (1 << `REG_ADDR_SIZE)

`define reg_reg_op 0110011
`define reg_imm_alu_op 0010011
`define load_op  0000011
`define store_op 0100011

`define MEM_WORD_SIZE 32
`define MEM_ADDR_SIZE 32
`define MEMS (1 << `MEM_ADDR_SIZE)

