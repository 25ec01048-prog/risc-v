
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
        put_inst( 0, 32'h00100093);
        put_inst( 4, 32'h00A00113);
        put_inst( 8, 32'h00000193);
        put_inst(12, 32'h00000213);
        put_inst(16, 32'h00000293);
        put_inst(20, 32'h00120233);
        put_inst(24, 32'h00128293);
        put_inst(28, 32'hFE12CCE3);
        put_inst(32, 32'h004181B3);
        put_inst(36, 32'h00108093);
        put_inst(40, 32'hFE1152E3);
        put_inst(44, 32'hFD5FF3EF);
    end

endmodule
