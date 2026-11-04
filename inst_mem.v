`include "common_define.v"

module inst_mem(
    input [(`INST_ADDR_SIZE-1):0]inst_addr,
    output wire [`INST_SIZE-1:0] inst_out
)   ;
    reg [`INST_SIZE-1:0] memory[0:`INST_MEM_SIZE-1] ;

    assign inst_out = memory [inst_addr];

    initial begin
        $readmemb("instructions.hex", memory);
    end


endmodule