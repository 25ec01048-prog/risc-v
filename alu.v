`include "common_define.v"


module alu (
    input [`REG_SIZE-1:0] in1,
    input [`REG_SIZE-1:0] in2,
    output reg [`REG_SIZE-1:0] oData,
    input [3:0] alu_sel
);
    always @(*)
        case (alu_sel)
            4'd0: oData = in1 + in2;
            4'b1000: oData = in1 - in2;
            4'b0001: oData = in1 << in2;
            4'b0010: oData = ($signed(in1) < $signed(in2));
            4'b0011: oData = ($unsigned(in1) < $unsigned(in2));
            4'b0100: oData = in1 ^ in2;
            4'b0101: oData = in1 >> in2;
            4'b1101: oData =   $signed(in1) >>> in2;
            4'b0110: oData = in1 | in2;
            4'b0111: oData = in1 & in2;
            default: oData = 32'd0;
        endcase

endmodule