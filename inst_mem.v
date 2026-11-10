
`include "common_define.v"

module inst_mem(
    input [(`INST_ADDR_SIZE-1):0] inst_addr,
    output wire [`INST_SIZE-1:0] inst_out
);

    reg [7:0] memory [0:`INST_MEM_SIZE-1];

    // Store each 32-bit instruction in little-endian format
    task put_inst;
        input integer addr;
        input [31:0] inst;
        begin
            memory[addr]   = inst[7:0];
            memory[addr+1] = inst[15:8];
            memory[addr+2] = inst[23:16];
            memory[addr+3] = inst[31:24];
        end
    endtask

    assign inst_out = {
        memory[inst_addr+2'd3],
        memory[inst_addr+2'd2],
        memory[inst_addr+2'd1],
        memory[inst_addr]
    };

    initial begin

        // LUI and AUIPC
        put_inst(  0, 32'h00000F37); // lui   x30, 0
        put_inst(  4, 32'h00000C17); // auipc x24, 0

        // Register initialization
        put_inst(  8, 32'h00A00093); // addi x1, x0, 10
        put_inst( 12, 32'h00500113); // addi x2, x0, 5

        // JAL and JALR
        put_inst( 16, 32'h00800FEF); // jal  x31, 8
        put_inst( 20, 32'h00000013); // nop
        put_inst( 24, 32'h01C00BE7); // jalr x23, 28(x0)

        // More register initialization
        put_inst( 28, 32'h00100313); // addi x6, x0, 1
        put_inst( 32, 32'h01000613); // addi x12, x0, 16

        // R-type instructions
        put_inst( 36, 32'h002081B3); // add  x3, x1, x2
        put_inst( 40, 32'h40208233); // sub  x4, x1, x2
        put_inst( 44, 32'h006112B3); // sll  x5, x2, x6
        put_inst( 48, 32'h001123B3); // slt  x7, x2, x1
        put_inst( 52, 32'h00113433); // sltu x8, x2, x1
        put_inst( 56, 32'h0020C4B3); // xor  x9, x1, x2
        put_inst( 60, 32'h0060D533); // srl  x10, x1, x6
        put_inst( 64, 32'h406655B3); // sra  x11, x12, x6
        put_inst( 68, 32'h0020E6B3); // or   x13, x1, x2
        put_inst( 72, 32'h0020F733); // and  x14, x1, x2

        // I-type ALU instructions
        put_inst( 76, 32'h00308793); // addi x15, x1, 3
        put_inst( 80, 32'h00A12813); // slti x16, x2, 10
        put_inst( 84, 32'h00A13893); // sltiu x17, x2, 10
        put_inst( 88, 32'h0030C913); // xori x18, x1, 3
        put_inst( 92, 32'h0040E993); // ori  x19, x1, 4
        put_inst( 96, 32'h0060FA13); // andi x20, x1, 6
        put_inst(100, 32'h00111A93); // slli x21, x2, 1
        put_inst(104, 32'h0010DB13); // srli x22, x1, 1
        put_inst(108, 32'h40165B93); // srai x23, x12, 1

        // Store instructions
        put_inst(112, 32'h00302023); // sw x3, 0(x0)
        put_inst(116, 32'h00101223); // sh x1, 4(x0)
        put_inst(120, 32'h00200323); // sb x2, 6(x0)

        // Load instructions
        put_inst(124, 32'h00600C83); // lb  x25, 6(x0)
        put_inst(128, 32'h00401D03); // lh  x26, 4(x0)
        put_inst(132, 32'h00002D83); // lw  x27, 0(x0)
        put_inst(136, 32'h00604E03); // lbu x28, 6(x0)
        put_inst(140, 32'h00405E83); // lhu x29, 4(x0)

        // Branch instructions
        put_inst(144, 32'h00208463); // beq  x1, x2, 8
        put_inst(148, 32'h00000013); // nop

        put_inst(152, 32'h00209463); // bne  x1, x2, 8
        put_inst(156, 32'h00000013); // nop

        put_inst(160, 32'h0020C463); // blt  x1, x2, 8
        put_inst(164, 32'h00000013); // nop

        put_inst(168, 32'h0020D463); // bge  x1, x2, 8
        put_inst(172, 32'h00000013); // nop

        put_inst(176, 32'h0020E463); // bltu x1, x2, 8
        put_inst(180, 32'h00000013); // nop

        put_inst(184, 32'h0020F463); // bgeu x1, x2, 8
        put_inst(188, 32'h00000013); // nop

        // Infinite loop back to address 0
        put_inst(192, 32'hF41FF06F); // jal x0, -192

    end

endmodule
