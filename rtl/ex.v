`include "ins_defines.v"


module ex (

    input clk,
    input rst,

    input wire [31:0] ins_i,
    input wire [31:0] ins_addr_i,

    output reg [31:0] ins_o,
    output reg [31:0] ins_addr_o,

    input wire [31:0] rs1_data_i,
    input wire [31:0] rs2_data_i,

    output reg [4:0]  rd_addr_o,
    output reg [31:0] rd_data_o,
    output reg        rd_wr_en,

    output reg [31:0] jump_addr_o,
    output reg   	  jump_en_o,
	output reg  	  hold_flag_o

);

wire[6:0] opcode; 
wire[4:0] rd; 
wire[2:0] func3; 
wire[4:0] rs1;
wire[4:0] rs2;
wire[6:0] func7;




assign opcode = ins_i[6:0];
assign rd 	  = ins_i[11:7];
assign func3  = ins_i[14:12];
assign rs1 	  = ins_i[19:15];
assign rs2 	  = ins_i[24:20];
assign func7  = ins_i[31:25];

reg [31:0] ram_addr_o;
reg        ram_wd_en;
reg        ram_rd_en;
reg [2:0]  ram_size_o;
wire [31:0] ram_data_i;
reg [31:0] ram_data_o;

//ALU
wire[31:0] imm_I= {{21{ins_i[31]}}, ins_i[30:20]};
wire[31:0] imm_S= {{21{ins_i[31]}}, ins_i[30:25], ins_i[11:8], ins_i[7]};
wire[31:0] imm_B= {{20{ins_i[31]}}, ins_i[7], ins_i[30:25], ins_i[11:8], 1'b0};
wire[31:0] imm_U= {ins_i[31:12], 12'h0};
wire[31:0] imm_J= {{12{ins_i[31]}}, ins_i[19:12], ins_i[20], ins_i[30:21], 1'b0};

reg [31:0] op1_reg;
reg [31:0] op2_reg;

wire [31:0] op1 = op1_reg;
wire [31:0] op2 = op2_reg;

wire [31:0] op1_add_op2;
wire [31:0] op1_sub_op2;

wire [31:0] op1_and_op2;
wire [31:0] op1_or_op2;
wire [31:0] op1_xor_op2;

wire [31:0] op1_equal_op2;
wire [31:0] op1_signed_comp_op2;
wire [31:0] op1_unsigned_comp_op2;

wire [31:0] op1_sll_op2;
wire [31:0] op1_srl_op2;
wire [31:0] op1_sra_op2;

assign op1_add_op2 = op1 + op2;
assign op1_sub_op2 = op1 - op2;

assign op1_and_op2 = op1 & op2;
assign op1_or_op2 = op1 | op2;
assign op1_xor_op2 = op1 ^ op2;

assign op1_equal_op2 = op1 == op2;
assign op1_signed_comp_op2 = op1[31] != op2[31]? op1[31] : (op1 < op2);
assign op1_unsigned_comp_op2 = op1 < op2;

assign op1_sll_op2 = op1 << op2[4:0];
assign op1_srl_op2 = op1 >> op2[4:0];
assign op1_sra_op2 = op1 >> op2[4:0] | ({32{op1[31]}} & ~(32'hFFFF_FFFF >> op2[4:0]));

wire [31:0] addr_dest;
reg  [31:0] addr_base;
reg  [31:0] addr_offset;

assign addr_dest = addr_base + addr_offset;


wire [31:0] op1_mul_op2;
wire [31:0] op1_mul_op2_h;
reg  mul_en;


mul u_mul(
    .rst             (rst             ),
    .op1             (op1             ),
    .op2             (op2             ),
    .func3           (func3           ),
    .mul_en          (mul_en          ),
    .op1_mul_op2_o   (op1_mul_op2   ),
    .op1_mul_op2_h_o (op1_mul_op2_h )
);

wire [31:0] op1_div_op2;
wire [31:0] op1_div_op2_rem;
reg div_en;
reg div_en_reg;
wire div_busy;
wire div_wd;

div_test u_div(
    .clk        (clk        ),
    .rst        (rst        ),
    .dividend_i (op1 ),
    .divisor_i  (op2  ),
    .div_en     (div_en     ),
    .signed_i   (~func3[0]   ),
    .output_o   (op1_div_op2   ),
    .rem_o      (op1_div_op2_rem      ),
    .wd_en      (div_wd      ),
    .busy_o     (div_busy     )
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        div_en_reg = 0;
    end
    else begin
        div_en_reg <= div_en;
    end
end



always @(*) begin
    rd_addr_o = rd;
    case (opcode)

        //I type

        `INST_TYPE_I:begin      
            jump_addr_o = `x0;
            jump_en_o	= 1'b0;
            hold_flag_o = 1'b0;	

            ram_addr_o = 32'h0;
            ram_data_o = 32'h0;
            ram_size_o = 4'd0;
            ram_wd_en = 1'h0;

            mul_en = 1'b0;
            div_en = 1'b0;

            op1_reg = rs1_data_i;
            op2_reg = imm_I;
            case(func3)
                `INST_ADDI:begin        //addi
                    rd_data_o = op1_add_op2;
                   
                end
                `INST_SLTI:begin        //signed compare
                    
                    rd_data_o = op1_signed_comp_op2;
                    
                end
                `INST_SLTIU: begin      //unsigned compare
                    
                    rd_data_o = op1_unsigned_comp_op2;
                end
                `INST_ANDI: begin       //andi
                    rd_data_o = op1_and_op2;
                    
                end
                `INST_ORI: begin        //ori
                    rd_data_o = op1_or_op2;
                    
                end
                `INST_XORI: begin       //xori
                    rd_data_o = op1_xor_op2;
                    
                end
                `INST_SLLI: begin       //SLLI
                    rd_data_o = op1_sll_op2;
                    
                end
                `INST_SRI: begin
                    case (func7)
                        7'b0: begin     //SRLI
                            rd_data_o = op1_srl_op2;
                            
                        end
                        7'b0100000: begin   //SRAI
                            rd_data_o = op1_sra_op2;
                            
                        end 
                        default: begin  
                            rd_data_o = 32'b0;
                            rd_addr_o = `x0;
                            rd_wr_en  = 1'b0;
                        end
                    endcase
                end
                default:begin
                    rd_data_o = 32'b0;
                    rd_addr_o = 5'b0;
                    rd_wr_en  = 1'b0;
                end
            endcase

            rd_wr_en = 1'b1;
        end

        `INST_LUI: begin        //lui
            jump_addr_o = 32'b0;
            jump_en_o	= 1'b0;
            hold_flag_o = 1'b0;

            ram_addr_o = 32'h0;
            ram_data_o = 32'h0;
            ram_size_o = 3'd0;
            ram_wd_en = 1'h0;

            mul_en = 1'b0;
            div_en = 1'b0;

            rd_data_o = imm_U;
            rd_addr_o = rd;
            rd_wr_en = 1'b1;	

         end

        `INST_AUIPC: begin      //AUIPC
            jump_addr_o = 32'b0;
            jump_en_o	= 1'b0;
            hold_flag_o = 1'b0;

            ram_addr_o = 32'h0;
            ram_data_o = 32'h0;
            ram_size_o = 3'd0;
            ram_wd_en = 1'h0;

            mul_en = 1'b0;
            div_en = 1'b0;

            addr_base = ins_addr_i;
            addr_offset = imm_U;
            rd_data_o = addr_dest;
            rd_addr_o = rd;
            rd_wr_en = 1'b1;
        end

        //R type

        `INST_TYPE_R_M: begin
            jump_addr_o = 32'b0;
            jump_en_o	= 1'b0;
            hold_flag_o = 1'b0;	

            ram_addr_o = 32'h0;
            ram_data_o = 32'h0;
            ram_size_o = 3'd0;
            ram_wd_en = 1'h0;

            op1_reg = rs1_data_i;
            op2_reg = rs2_data_i;

            rd_addr_o = rd;

            
            if(func7 == 7'b000_0000 || func7 == 7'b010_0000)begin
                mul_en = 1'b0;
                div_en = 1'b0;
            
                case(func3)
                    `INST_ADD_SUB: begin
                        if(func7 == 7'b000_0000)begin//add
                            rd_data_o = op1_add_op2;
                            
                        end
                        else if(func7 == 7'b010_0000)begin  //sub
                            rd_data_o = op1_sub_op2;
                            
                        end
                        else begin
                            rd_data_o = 32'b0;
                            rd_addr_o = `x0;
                            rd_wr_en  = 1'b0;
                        end
                    end
                    `INST_SLL: begin        //sll
                        rd_data_o = op1_sll_op2;
                        
                    end
                    `INST_SLT: begin        //slt signed compare
                        
                        rd_data_o = op1_signed_comp_op2;
                    end
                    `INST_SLTU: begin       //sltu unsigned compare
                        
                        rd_data_o = op1_unsigned_comp_op2;
                    end
                    `INST_XOR: begin        //xor
                        rd_data_o = op1_xor_op2;
                        
                    end
                    `INST_SR: begin
                        case (func7)
                            7'b0:begin      //srl logical
                                rd_data_o = op1_srl_op2;
                                
                            end 
                            7'b010_0000: begin      //sra 
                                rd_data_o = op1_sra_op2;
                                
                            end
                            default: begin
                                rd_data_o = 32'b0;
                                rd_addr_o = `x0;
                                rd_wr_en  = 1'b0;
                            end
                        endcase
                    end
                    `INST_OR: begin     //or
                        rd_data_o = op1_or_op2;
                        
                    end
                    `INST_AND: begin        //and
                        rd_data_o = op1_and_op2;
                    
                    end
                    default:begin
                        rd_data_o = 32'b0;
                        rd_addr_o = `x0;
                        rd_wr_en  = 1'b0;
                    end
                endcase
                
            end
            else if(func7 == 7'b1)begin
                 if(func3[2] == 0)begin     //mul
                    mul_en = 1'b1;
                    div_en = 1'b0;
                    rd_data_o = func3 == 3'h0 ? op1_mul_op2 : op1_mul_op2_h;

                    rd_wr_en = 1'b1;
                 end
                 else if (func3[2] == 1) begin     
                    mul_en = 1'b0;
                    div_en = 1'b1;
                    // hold_flag_o = div_busy;
                    hold_flag_o = 1'b1;
                    if (~div_en_reg) 
                        hold_flag_o = 1'b1;
                    else 
                        hold_flag_o = div_busy;
                    
                    if (func3[1]) 
                        rd_data_o = op1_div_op2_rem;    //rem
                    else
                        rd_data_o = op1_div_op2;        //div
                        
                    rd_wr_en = div_wd;
                 end
            end
            // rd_wr_en = 1'b1;
        end




        `INST_TYPE_B: begin
            rd_data_o = 32'b0;
            rd_addr_o = `x0;
            rd_wr_en  = 1'b0;

            ram_addr_o = 32'h0;
            ram_data_o = 32'h0;
            ram_size_o = 3'd0;
            ram_wd_en = 1'h0;

            hold_flag_o = 1'b0;

            mul_en = 1'b0;
            div_en = 1'b0;

            addr_base = ins_addr_i;
            addr_offset = imm_B;
            jump_addr_o = addr_dest;

            op1_reg = rs1_data_i;
            op2_reg = rs2_data_i;

            case (func3)
                `INST_BEQ: begin        //beq
                   
                    jump_en_o = op1_equal_op2;
                end
                `INST_BNE: begin        //bne
                   
                    jump_en_o = ~op1_equal_op2;
                end
                `INST_BLT: begin        //blt signed
                    
                    jump_en_o = op1_signed_comp_op2;
                end
                `INST_BLTU: begin       //bltu unsigned
                    
                    jump_en_o = op1_unsigned_comp_op2;
                end
                `INST_BGE: begin        //bge signed
                    
                    jump_en_o = ~op1_signed_comp_op2;
                end
                `INST_BGEU: begin       //bgeu unsigned
                    
                    jump_en_o = ~op1_unsigned_comp_op2;
                end 
                default: begin
                    jump_addr_o = 32'b0;
                    jump_en_o	= 1'b0;
                    hold_flag_o = 1'b0;
                end
            endcase
        end

        `INST_JAL: begin        //jal

            ram_addr_o = 32'h0;
            ram_data_o = 32'h0;
            ram_size_o = 3'd0;
            ram_wd_en = 1'h0;
            rd_addr_o = rd;

            op1_reg = ins_addr_i;
            op2_reg = 32'h4;
            rd_data_o = op1_add_op2;
            rd_wr_en = 1'b1;

            addr_base = ins_addr_i;
            addr_offset = imm_J;
            jump_addr_o = addr_dest;
            jump_en_o = 1'b1;
            hold_flag_o = 1'b0;
        end

        `INST_JALR: begin       //jalr
            rd_addr_o = rd;
            op1_reg = ins_addr_i;
            op2_reg = 32'h4;
            rd_data_o = op1_add_op2;
            rd_wr_en = 1'b1;

            addr_base = rs1_data_i;
            addr_offset = imm_I;
            jump_addr_o = addr_dest;
            jump_en_o = 1'b1;
            hold_flag_o = 1'b0;

           
        end

        `INST_TYPE_S: begin
            rd_data_o = 32'b0;
            rd_addr_o = `x0;
            rd_wr_en  = 1'b0;

            jump_addr_o = 32'b0;
            jump_en_o	= 1'b0;
            hold_flag_o = 1'b0;

            addr_base = rs1_data_i;
            addr_offset = imm_S;
            ram_addr_o = addr_dest;

            op1_reg = rs2_data_i;
            

            case (func3)
                `INST_SB: begin     //sb
                    ram_size_o = 3'd1;
                    op2_reg = 32'h0000_00ff;
                end
                `INST_SH: begin     //sh
                    ram_size_o = 3'd2;
                    op2_reg = 32'h0000_ffff;
                end
                `INST_SW: begin     //sw
                    ram_size_o = 3'd4;
                    op2_reg = 32'hffff_ffff;
                end
                default: begin
                    ram_size_o = 3'd0;
                    op2_reg = 32'h0000_0000;
                end
            endcase

            ram_data_o = op1_and_op2;
            ram_wd_en = 1'b1;
        end

        `INST_TYPE_L: begin
            jump_addr_o = 32'b0;
            jump_en_o	= 1'b0;
            hold_flag_o = 1'b0;

            rd_addr_o = rd;

            ram_wd_en = 1'b0;
            ram_data_o = 32'h0;

            addr_base = rs1_data_i;
            addr_offset = imm_I;
            ram_addr_o = addr_dest;

            ram_rd_en = 1'b1;

            case (func3)
                `INST_LB: begin     //lb
                    ram_size_o = 3'd1;
                    // ram_rd_en = 1'b1;
                    op1_reg = {24'h0, ram_data_i[7:0]};
                    op2_reg = {{24{ram_data_i[7]}}, 8'h00};
                    // rd_data_o = op1_and_op2;
                end
                `INST_LH: begin     //lh
                    ram_size_o = 3'd2;
                    // ram_rd_en = 1'b1;
                    op1_reg= {16'h0, ram_data_i[15:0]};
                    op2_reg = {{16{ram_data_i[15]}}, 16'h0000};
                    // rd_data_o = op1_and_op2;
                end
                `INST_LW: begin     //lw
                    ram_size_o = 3'd4;
                    // ram_rd_en = 1'b1;
                    op1_reg = ram_data_i;
                    op2_reg = 32'h0;
                    // rd_data_o = op1_and_op2;
                end
                `INST_LBU: begin        //lbu
                    ram_size_o = 3'd1;
                    // ram_rd_en = 1'b1;
                    op1_reg = {24'h0, ram_data_i[7:0]};
                    op2_reg = 32'h0;
                    // rd_data_o = op1_and_op2;
                end
                `INST_LHU: begin        //lhu
                    ram_size_o = 3'd2;
                    // ram_rd_en = 1'b1;
                    op1_reg = {16'h0, ram_data_i[15:0]};
                    op2_reg = 32'h0; 
                    // rd_data_o = op1_and_op2;
                end
                default: begin
                    // ram_rd_en = 0;
                    ram_size_o = 0;
                    op1_reg = 32'h0;
                    op2_reg = 32'h0;
                end
            endcase
            rd_addr_o = rd;
            rd_data_o = op1_or_op2;
            rd_wr_en = 1'b1;
            
        end

        default: begin
            rd_data_o = 32'b0;
            rd_addr_o = `x0;
            rd_wr_en  = 1'b0;

            jump_addr_o = 32'b0;
            jump_en_o	= 1'b0;
            hold_flag_o = 1'b0;

            ram_addr_o = 32'h0;
            ram_data_o = 32'h0;
            ram_size_o = 3'd0;
            ram_wd_en = 1'h0;
            rd_addr_o = rd;
        end
    endcase
end

ram u_ram(
    .clk       (clk       ),
    .rd_addr_i (ram_addr_o ),
    .rd_en     (ram_rd_en     ),
    .rd_size_i (ram_size_o ),
    .rd_data_o (ram_data_i ),
    .wd_addr_i (ram_addr_o ),
    .wd_en     (ram_wd_en     ),
    .wd_size_i (ram_size_o ),
    .wd_data_i (ram_data_o )
);



endmodule