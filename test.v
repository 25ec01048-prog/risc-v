`include "common_define.v"

module tb_;
    reg clk;
    
    risc_v rs1(.clk(clk));
    localparam CLK_PERIOD = 10;

    always  #(CLK_PERIOD/2) clk=~clk;
    initial begin
        $dumpfile("tb_.vcd");
        $dumpvars(0, tb_);
    end

    initial begin
        clk = 0;
        #1000 $finish();
    end

endmodule