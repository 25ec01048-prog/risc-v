`include "common_define.v"

module main_memory(
    input wE,
    input [2:0] w_type,
    input [`MEM_ADDR_SIZE-1:0] raddr,
    input [`MEM_ADDR_SIZE-1:0] waddr,
    input [`MEM_WORD_SIZE-1:0] data_in,
    output [`MEM_WORD_SIZE-1:0] data_out,
    input clk
)
    reg [7:0] memory [0:`MEMS-1];

    assign data_out =  {memory[raddr+2'd3] , memory[raddr+2'd2],memory[raddr+2'd1],memory[raddr+2'd0]};
    always @(posedge clk)
        case (w_type):
            3'd0:{memory[waddr+2'd0]} <= wE? data_in[7:0]:  {memory[waddr+2'd0]};
            3'd1:{memory[waddr+2'd1],memory[waddr+2'd0]} <= wE? data_in[15:0]:  {memory[waddr+2'd1],memory[waddr+2'd0]};
            3'd2:{memory[waddr+2'd3] , memory[waddr+2'd2],memory[waddr+2'd1],memory[waddr+2'd0]} <= wE? data_in:  {memory[waddr+2'd3] , memory[waddr+2'd2],memory[waddr+2'd1],memory[waddr+2'd0]};
        endcase
endmodule       