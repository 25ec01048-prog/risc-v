`include "common_define.v"

module main_memory(
    input wE,
    input [2:0] w_type,
    input [`MEM_ADDR_SIZE-1:0] raddr,
    input [`MEM_ADDR_SIZE-1:0] waddr,
    input [`MEM_WORD_SIZE-1:0] data_in,
    output [`MEM_WORD_SIZE-1:0] data_out,
    input clk
);
    reg [7:0] mem  [0: `MEMS-1];

    assign data_out =  {mem[raddr+2'd3] , mem[raddr+2'd2],mem[raddr+2'd1],mem[raddr+2'd0]};
    always @(negedge clk)
    if (wE)
        case (w_type)
            3'd0:{mem[waddr+2'd0]} <= data_in[7:0];
            3'd1:{mem[waddr+2'd1],mem[waddr+2'd0]} <= data_in[15:0];
            3'd2:{mem[waddr+2'd3] , mem[waddr+2'd2],mem[waddr+2'd1],mem[waddr+2'd0]} <=  data_in;
        endcase
endmodule       