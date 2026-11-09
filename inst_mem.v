`include "common_define.v"

module inst_mem(
    input [(`INST_ADDR_SIZE-1):0]inst_addr,
    output wire [`INST_SIZE-1:0] inst_out
)   ;
    reg [7:0] memory[0:`INST_MEM_SIZE-1] ;

    assign inst_out = {
        memory[inst_addr+2'd3],
        memory[inst_addr+2'd2],
        memory[inst_addr+2'd1],
        memory[inst_addr]};
    
    initial begin
        $readmemb("instructions.hex", memory);
        // $monitor("%h %h", inst_addr, inst_out);
    end


endmodule