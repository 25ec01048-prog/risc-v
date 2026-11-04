`include "common_define.v"
module pc(
    input clk,
    input [`INST_ADDR_SIZE-1:0] inst_addr_in,
    output reg [`INST_ADDR_SIZE-1:0] inst_addr_out
);
    always @(posedge clk) begin
        inst_addr_out <= inst_addr_in; 
    end

endmodule