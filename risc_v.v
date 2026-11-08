
module risc_v(
    input clk
);
    reg [`INST_ADDR_SIZE-1:0] inst_addr;
    wire [`INST_SIZE-1:0] instruction;
    wire [`INST_ADDR_SIZE-1:0] inst_addr_o;
    reg wE_REG;
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
    reg [12:0]  branch_offset;
    reg [19:0] jal_offset;


    reg wE_MEM;
    reg [`MEM_ADDR_SIZE-1:0] raddr_mem;
    reg [`MEM_ADDR_SIZE-1:0] waddr_mem;
    reg [`MEM_WORD_SIZE-1:0] mem_in;
    wire [`MEM_WORD_SIZE-1:0] mem_out;
    reg [2:0] mem_in_type;

    


    pc pc1(.clk(clk),.inst_addr_in(inst_addr), .inst_addr_out(inst_addr_o));
    inst_mem inst_mem1(.inst_addr(inst_addr_o), .inst_out(instruction)); 
    regfile reg1(.clk(clk), .wE(wE_REG), .waddr(waddr), .wData(wData), .raddr_1(raddr_1), .raddr_2(raddr_2), .rout_1(regout_1), .rout_2(regout_2));
    main_memory mem(.wE(wE_MEM),.w_type(mem_in_type), .clk(clk), .raddr(raddr_mem), .waddr(waddr_mem), .data_in(mem_in), .data_out(mem_out));

    alu alu1(.alu_sel(alu_sel), .in1(aluin_1), .in2(aluin_2), .oData(alu_out));

    always @(*)
    begin
        if (instruction[6:0] == 7'b`branch_op)
        begin
            
            case (instruction[14:12])
                3'd0: 
                begin 
                     $display("%h %h %h ", inst_addr_o, regout_1, regout_2);
                    if(regout_1 == regout_2) 
                    begin inst_addr <= inst_addr_o +branch_offset;end
                    else inst_addr <= inst_addr_o +4;
                end
                3'd1: 
                begin 
                    if(regout_1 != regout_2) inst_addr <= inst_addr_o +branch_offset;
                    else inst_addr <= inst_addr_o +4;
                end
                3'd4: 
                begin 
                    if($signed(regout_1) < $signed(regout_2)) inst_addr <= inst_addr_o +branch_offset;
                    else inst_addr <= inst_addr_o +4;
                end
                3'd5: 
                begin 
                    if($signed(regout_1) >= $signed(regout_2)) inst_addr <= inst_addr_o +branch_offset;
                    else inst_addr <= inst_addr_o +4;
                end
                3'd6: 
                begin 
                    if($unsigned(regout_1) < $unsigned(regout_2)) inst_addr <= inst_addr_o +branch_offset;
                    else inst_addr <= inst_addr_o +4;
                end
                3'd7: 
                begin 
                    if($unsigned(regout_1) >= $unsigned(regout_2)) inst_addr <= inst_addr_o +branch_offset;
                    else inst_addr <= inst_addr_o +4;
                end
                default:
                begin
                    inst_addr <= inst_addr_o +4;
                end
            endcase
        end
        else if (instruction[6:0] == 7'b`JAL_op)
            begin
                wE_REG = 1;
                waddr = instruction[11:7];
                wData = inst_addr_o + 4;
                inst_addr = inst_addr_o + $signed(jal_offset);
            end
        else if (instruction[6:0] == `JALR_op)
            begin
                wE_REG = 1;
                waddr = instruction[11:7];
                wData = inst_addr_o + 4;
                inst_addr = regout_1 + $signed(instruction[31:20]); 
            end
        else
        begin
            
        inst_addr <= inst_addr_o + 4;
        end
    end

    always @(*)
    begin
        case (instruction[6:0])
        7'b`reg_reg_op:
            begin
                wE_MEM = 0;
                mem_in = 0;
                wE_REG = 1;
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
                wE_MEM = 0;
                mem_in = 0;
                wE_REG = 1;
                alu_sel = (instruction[14:12] == 3'b101 )? {instruction[30], instruction[14:12]}: {1'b0, instruction[14:12]} ;          
                raddr_1 = instruction[19:15];
                waddr = instruction[11:7];
                aluin_1 = regout_1;
                aluin_2 = $signed(instruction[31:20]);
                wData = alu_out;
            end

        7'b`load_op:

            begin
                wE_MEM = 0;
                mem_in = 0;
                alu_sel = 4'd0;
                raddr_1 = instruction[19:15];
                aluin_1 = regout_1; 
                aluin_2 = $signed(instruction[31:20]);
                raddr_mem = alu_out;
                waddr = instruction[11:7];
                case(instruction[14:12])
                3'd0: begin   
                        wE_REG = 1;                   
                        wData = $signed(mem_out[7:0]);
                    end
                3'd1: begin
                        wE_REG = 1;
                        wData = $signed(mem_out[15:0]);
                    end
                3'd2: begin
                        wE_REG = 1;
                        wData = mem_out;
                    end
                3'd4: begin
                        wE_REG = 1;
                        wData = $unsigned(mem_out[7:0]);
                    end
                3'd5: begin
                        wE_REG = 1;
                        wData = $unsigned(mem_out[15:0]);
                    end
                default : 
                begin
                        wE_REG = 0;
                        wData = 0;
                    end
                endcase
            end
        
        7'b`store_op:
            begin
                alu_sel = 4'd0;
                raddr_1 = instruction[19:15];
                raddr_2 = instruction[24:20];
                aluin_1 = regout_1; 
                aluin_2 = $signed(instruction[31:20]);
                mem_in = regout_2;
                wE_MEM =1;
                waddr_mem = alu_out;
                mem_in_type = instruction[14:12];              

            end
        
        7'b`LUI_op:
        begin
            wE_REG = 1;
            waddr = instruction[11:7];
            wData = {instruction[31:12], 12'b0};
        end

        7'b`AUIPIC_op:
        begin
            wE_REG = 1;
            waddr = instruction[11:7];
            wData = {instruction[31:12], 12'b0} + inst_addr_o;
        end

        7'b`branch_op:
        begin
            branch_offset = {instruction[31], instruction[7],instruction[30:25],instruction[11:8],1'b0};
            raddr_2 = instruction[24:20];
            raddr_1 = instruction[19:15];
        end

        7'b`JAL_op:
        begin
            jal_offset = {instruction[31], instruction[19:12], instruction[20], instruction[30:21]};
        end



        default:
        
            begin
                wE_MEM =0;
                wE_REG = 0;
                wData = 0;
                mem_in = 0;
                raddr_1 =0 ;
                raddr_2 =0;

            end

        
        endcase
    end
    
    initial begin
        inst_addr = 0;
    end

endmodule