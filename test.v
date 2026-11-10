`include "common_define.v"

module tb_;
    reg clk;
    wire [6:0] opCode;
    reg [`REG_ADDR_SIZE-1:0] userin = 5'd29;
    wire [5: 0] userout;
    risc_v rs1(.clk(clk), .opCode(opCode),.userin(userin), .userout(userout));
    localparam CLK_PERIOD = 10;

    always   begin 
        #(CLK_PERIOD/2)
        clk=~clk;
        userin = userin+1; 
        end
    initial begin
        $dumpfile("tb_.vcd");
        $dumpvars(0, tb_);
    end

    initial begin
        clk = 0;
        #500 $finish();
    end

endmodule