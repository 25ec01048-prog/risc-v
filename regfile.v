module regfile (
    input clk,
    input wE,
    input [`REG_ADDR_SIZE-1:0] waddr,
    input [`REG_SIZE-1: 0] wData,
    input [`REG_ADDR_SIZE-1:0] raddr_1,
    input [`REG_ADDR_SIZE-1:0] raddr_2,
    output [`REG_SIZE-1: 0] rout_1,
    output [`REG_SIZE-1: 0] rout_2
);
    reg [`REG_SIZE-1:0] registers [0:`REGISTERS-1];
    initial
    begin
        registers[0] =   `REG_SIZE'd0;
        registers[1] =   `REG_SIZE'd10;
        registers[2] =   `REG_SIZE'd5;
    end
    

    assign rout_1 = registers[raddr_1];
    assign rout_2 = registers[raddr_2];

    always @(posedge clk) 
    if (wE) registers[waddr] <= wData;
    
endmodule