module regfile (
    input clk,
    input wE,
    input [`REG_ADDR_SIZE-1:0] waddr,
    input [`REG_SIZE-1: 0] wData,
    input [`REG_ADDR_SIZE-1:0] raddr_1,
    input [`REG_ADDR_SIZE-1:0] raddr_2,
    output [`REG_SIZE-1: 0] addr_1,
    output [`REG_SIZE-1: 0] addr_2
);
    reg [`REG_SIZE-1:0] registers [0:`REGISTERS-1];
    initial
    begin
        registers[0] =   `REG_SIZE'd0;
        registers[1] =   `REG_SIZE'd10;
        registers[2] =   `REG_SIZE'd5;
    end
    

    assign addr_1 = registers[raddr_1];
    assign addr_2 = registers[raddr_2];

    always @(posedge clk) 
    if (wE) registers[waddr] <= wData;
    
endmodule