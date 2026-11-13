`include "common_define.v"
`timescale 1ns / 1ps

module tb_;
    reg clk_ssd;
    wire [6:0] opCode;
    reg [`REG_ADDR_SIZE-1:0] userin = 5'd29;
    wire [`INST_ADDR_SIZE-1: 0] c_inst_addr;
    wire [6:0] seg;
    wire [3:0] an;


    risc_v rs1(.clk100Mhz(clk_ssd),.userin(userin), .opCode(opCode), .c_inst_addr(c_inst_addr), .seg(seg), .an(an));
    localparam CLK_PERIOD = 2;

    always   begin 
        #(CLK_PERIOD/2)
        clk_ssd=~clk_ssd;
        
        userin = userin+1; 
        end


    initial begin
        $dumpfile("tb_.vcd");
        $dumpvars(0, tb_);
    end

    initial begin
        clk_ssd = 0;
        #50000 $finish();
    end

endmodule