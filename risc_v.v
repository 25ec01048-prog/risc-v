
module risc_v(
    input clk
);
    reg [`INST_ADDR_SIZE-1:0] inst_addr;
    wire [`INST_SIZE-1:0] instruction;
    wire [`INST_ADDR_SIZE-1:0] inst_addr_o;
    reg wE;
    reg [`REG_ADDR_SIZE-1:0] waddr;
    reg [`REG_SIZE-1: 0] wData;
    reg [`REG_ADDR_SIZE-1:0] raddr_1;
    reg [`REG_ADDR_SIZE-1:0] raddr_2;
    wire [`REG_SIZE-1: 0] regout_1;
    wire [`REG_SIZE-1: 0] regout_2;

    reg [3:0] alu_sel;
    reg [`REG_SIZE-1: 0] aluin_1;
    reg [`REG_SIZE-1: 0] aluin_2;  
    wire [`REG_SIZE-1:0] alu_out;


    pc pc1(.clk(clk),.inst_addr_in(inst_addr), .inst_addr_out(inst_addr_o));
    inst_mem inst_mem1(.inst_addr(inst_addr_o), .inst_out(instruction)); 
    regfile reg1(.clk(clk), .wE(wE), .waddr(waddr), .wData(wData), .raddr_1(raddr_1), .raddr_2(raddr_2), .addr_1(regout_1), .addr_2(regout_2));

    alu alu1(.alu_sel(alu_sel), .in1(aluin_1), .in2(aluin_2), .oData(alu_out));

    always @(inst_addr_o)
        inst_addr <= inst_addr_o + 1;

    always @(*)
    begin
        
        case (instruction[6:0])
        7'b`reg_reg_op:
            begin
                wE = 1;
                alu_sel = {instruction[30], instruction[14:12]};
                raddr_2 = instruction[24:20];
                raddr_1 = instruction[19:15];
                waddr = instruction[11:7];
                aluin_1 = regout_1;
                aluin_2 = regout_2;
                wData = alu_out;
            end
        7'b`reg_imm_alu_op:
            begin
                wE = 1;
                alu_sel = (instruction[14:12] == 3'b101 )? {instruction[30], instruction[14:12]}: {1'b0, instruction[14:12]} ;          
                raddr_1 = instruction[19:15];
                waddr = instruction[11:7];
                aluin_1 = regout_1;
                aluin_2 = $signed(instruction[31:20]);
                wData = alu_out;
            end

        default:
        
            begin
                wE = 0;
                wData = 0;
            end
        
        endcase
    end
    
    initial begin
        inst_addr = 0;
    end

endmodule