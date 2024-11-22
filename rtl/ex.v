`include "ins_defines.v"


module ex (
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
    output reg   	jump_en_o,
	output reg  	hold_flag_o
);

wire[6:0] opcode; 
wire[4:0] rd; 
wire[2:0] func3; 
wire[4:0] rs1;
wire[4:0] rs2;
wire[6:0] func7;
wire[31:0] imm_I= {{21{ins_i[31]}}, ins_i[30:20]};
wire[31:0] imm_S= {{21{ins_i[31]}}, ins_i[30:25], ins_i[11:8], ins_i[7]};
wire[31:0] imm_B= {{20{ins_i[31]}}, ins_i[7], ins_i[30:25], ins_i[11:8], 1'b0};
wire[31:0] imm_U= {ins_i[31:12], 12'h0};
wire[31:0] imm_J= {{12{ins_i[31]}}, ins_i[19:12], ins_i[20], ins_i[30:21], 1'b0};



assign opcode = ins_i[6:0];
assign rd 	  = ins_i[11:7];
assign func3  = ins_i[14:12];
assign rs1 	  = ins_i[19:15];
assign rs2 	  = ins_i[24:20];
assign func7  = ins_i[31:25];


// assign imm_I 
// assign imm    = ins_i[31:20];





always @(*) begin
    case (opcode)

        //I type

        `INST_TYPE_I:begin      
            jump_addr_o = `x0;
            jump_en_o	= 1'b0;
            hold_flag_o = 1'b0;	
            case(func3)
                `INST_ADDI:begin        //addi
                    rd_data_o = rs1_data_i + imm_I;
                    rd_addr_o = rd;
                    rd_wr_en  = 1'b1;
                end
                `INST_SLTI:begin        //signed compare
                    if((rs1_data_i[31] > imm_I[31]) ||  ((rs1_data_i[31] == imm_I[31])) && (rs1_data_i [30:0] < imm_I[30:0]))begin  
                        rd_data_o = 32'h1;
                        rd_addr_o = rd;
                        rd_wr_en  = 1'b1;
                    end
                    else begin
                        rd_data_o = 32'h0;
                        rd_addr_o = rd;
                        rd_wr_en  = 1'b1;
                    end
                end
                `INST_SLTIU: begin      //unsigned compare
                    if(rs1_data_i < imm_I)begin       //rs1<imm
                        rd_data_o = 32'h1;
                        rd_addr_o = rd;
                        rd_wr_en  = 1'b1;
                    end
                    else begin
                        rd_data_o = 32'h0;
                        rd_addr_o = rd;
                        rd_wr_en  = 1'b1;
                    end
                end
                `INST_ANDI: begin       //andi
                    rd_data_o = rs1_data_i & imm_I;
                    rd_addr_o = rd;
                    rd_wr_en  = 1'b1;
                end
                `INST_ORI: begin        //ori
                    rd_data_o = rs1_data_i | imm_I;
                    rd_addr_o = rd;
                    rd_wr_en  = 1'b1;
                end
                `INST_XORI: begin       //xori
                    rd_data_o = rs1_data_i ^ imm_I;
                    rd_addr_o = rd;
                    rd_wr_en  = 1'b1;
                end
                `INST_SLLI: begin       //SLLI
                    rd_data_o = rs1_data_i << imm_I[4:0];
                    rd_addr_o = rd;
                    rd_wr_en  = 1'b1;
                end
                `INST_SRI: begin
                    case (func7)
                        7'b0: begin     //SRLI
                            rd_data_o = rs1_data_i >> imm_I[4:0];
                            rd_addr_o = rd;
                            rd_wr_en  = 1'b1;
                        end
                        7'b0100000: begin   //SRAI
                            rd_data_o = (rs1_data_i >>> imm_I[4:0]) | ({32{rs1_data_i[31]}} & ~(32'hFFFF_FFFF >> imm_I[4:0]));
                            rd_addr_o = rd;
                            rd_wr_en  = 1'b1;
                        end 
                        default: begin  
                            rd_data_o = 32'b0;
                            rd_addr_o = 5'b0;
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
        end

        `INST_LUI: begin        //lui
            jump_addr_o = 32'b0;
            jump_en_o	= 1'b0;
            hold_flag_o = 1'b0;

            rd_data_o = imm_U;
            rd_addr_o = rd;
            rd_wr_en = 1'b1;	

         end

        `INST_AUIPC: begin      //AUIPC
            jump_addr_o = 32'b0;
            jump_en_o	= 1'b0;
            hold_flag_o = 1'b0;

            rd_data_o = ins_addr_i + imm_U;
            rd_addr_o = rd;
            rd_wr_en = 1'b1;
        end

        //R type

        `INST_TYPE_R_M: begin
            jump_addr_o = 32'b0;
            jump_en_o	= 1'b0;
            hold_flag_o = 1'b0;	
            case(func3)
                `INST_ADD_SUB: begin
                    if(func7 == 7'b000_0000)begin//add
                        rd_data_o = rs1_data_i + rs2_data_i;
                        rd_addr_o = rd;
                        rd_wr_en = 1'b1;
                    end
                    else if(func7 == 7'b010_0000)begin  //sub
                        rd_data_o = rs1_data_i - rs2_data_i;
                        rd_addr_o = rd;
                        rd_wr_en = 1'b1;
                    end
                    else begin
                        rd_data_o = 32'b0;
                        rd_addr_o = `x0;
                        rd_wr_en  = 1'b0;
                    end
                end
                `INST_SLL: begin        //sll
                    rd_data_o = rs1_data_i << rs2_data_i[4:0];
                    rd_addr_o = rd;
                    rd_wr_en = 1'b1;
                end
                `INST_SLT: begin        //slt signed compare
                    if((rs1_data_i[31] > rs2_data_i[31]) ||  ((rs1_data_i[31] == rs2_data_i[31])) && (rs1_data_i [30:0] < rs2_data_i[30:0]))begin  
                        rd_data_o = 32'h1;
                        rd_addr_o = rd;
                        rd_wr_en  = 1'b1;
                    end
                    else begin
                        rd_data_o = 32'h0;
                        rd_addr_o = rd;
                        rd_wr_en  = 1'b1;
                    end
                end
                `INST_SLTU: begin       //sltu unsigned compare
                    if(rs1_data_i < rs2_data_i)begin       //rs1<imm
                        rd_data_o = 32'h1;
                        rd_addr_o = rd;
                        rd_wr_en  = 1'b1;
                    end
                    else begin
                        rd_data_o = 32'h0;
                        rd_addr_o = rd;
                        rd_wr_en  = 1'b1;
                    end
                end
                `INST_XOR: begin        //xor
                    rd_data_o = rs1_data_i ^ rs2_data_i;
                    rd_addr_o = rd;
                    rd_wr_en  = 1'b1;
                end
                `INST_SR: begin
                    case (func7)
                        7'b0:begin      //srl logical
                            rd_data_o = rs1_data_i >> rs2_data_i[4:0];
                            rd_addr_o = rd;
                            rd_wr_en  = 1'b1;
                        end 
                        7'b010_0000: begin      //sra 
                            rd_data_o = (rs1_data_i >> rs2_data_i[4:0]) | ({32{rs1_data_i[31]}} & ~(32'hFFFF_FFFF >> rs2_data_i[4:0]));
                            rd_addr_o = rd;
                            rd_wr_en  = 1'b1;
                        end
                        default: begin
                            rd_data_o = 32'b0;
                            rd_addr_o = `x0;
                            rd_wr_en  = 1'b0;
                        end
                    endcase
                end
                `INST_OR: begin     //or
                    rd_data_o = rs1_data_i | rs2_data_i;
                    rd_addr_o = rd;
                    rd_wr_en  = 1'b1;
                end
                `INST_AND: begin        //and
                    rd_data_o = rs1_data_i & rs2_data_i;
                    rd_addr_o = rd;
                    rd_wr_en  = 1'b1;
                end
                default:begin
                    rd_data_o = 32'b0;
                    rd_addr_o = `x0;
                    rd_wr_en  = 1'b0;
                end
            endcase
        end




        `INST_TYPE_B: begin
            rd_data_o = 32'b0;
            rd_addr_o = `x0;
            rd_wr_en  = 1'b0;

            case (func3)
                `INST_BEQ: begin        //beq
                    if(rs1_data_i == rs2_data_i)begin
                        jump_addr_o = ins_addr_i + imm_B;
                        jump_en_o	= 1'b1;
                        hold_flag_o = 1'b0;
                        	
                    end
                end
                `INST_BNE: begin        //bne
                    if(rs1_data_i != rs2_data_i)begin
                        jump_addr_o = ins_addr_i + imm_B;
                        jump_en_o	= 1'b1;
                        hold_flag_o = 1'b0;
                        
                    end
                end
                `INST_BLT: begin        //blt signed
                    if(rs1_data_i[31] != rs2_data_i[31]? rs1_data_i[31]:(rs1_data_i < rs2_data_i))begin
                        jump_addr_o = ins_addr_i + imm_B;
                        jump_en_o	= 1'b1;
                        hold_flag_o = 1'b0;
                    end
                end
                `INST_BLTU: begin       //bltu unsigned
                    if(rs1_data_i < rs2_data_i)begin
                        jump_addr_o = ins_addr_i + imm_B;
                        jump_en_o	= 1'b1;
                        hold_flag_o = 1'b0;
                    end
                end
                `INST_BGE: begin        //bge signed
                    if(~(rs1_data_i[31] != rs2_data_i[31]? rs1_data_i[31]:(rs1_data_i < rs2_data_i)))begin
                        jump_addr_o = ins_addr_i + imm_B;
                        jump_en_o	= 1'b1;
                        hold_flag_o = 1'b0;
                    end
                end
                `INST_BGEU: begin       //bgeu unsigned
                    if(rs1_data_i >= rs2_data_i) begin
                        jump_addr_o = ins_addr_i + imm_B;
                        jump_en_o	= 1'b1;
                        hold_flag_o = 1'b0;
                    end
                end 
                default: begin
                    jump_addr_o = 32'b0;
                    jump_en_o	= 1'b0;
                    hold_flag_o = 1'b0;
                end
            endcase
        end

        `INST_JAL: begin        //jal
            rd_addr_o = rd;
            rd_data_o = ins_addr_i + 32'h4;
            rd_wr_en = 1'b1;

            jump_addr_o = ins_addr_i + imm_J;
            jump_en_o = 1'b1;
            hold_flag_o = 1'b0;
        end

        `INST_JALR: begin       //jalr
            rd_addr_o = rd;
            rd_data_o = ins_addr_i + 32'h4;
            rd_wr_en = 1'b1;

            jump_addr_o = (rs1_data_i + imm_I) & ~(32'h1);
            jump_en_o = 1'b1;
            hold_flag_o = 1'b0;
        end

        default: begin
            rd_data_o = 32'b0;
            rd_addr_o = `x0;
            rd_wr_en  = 1'b0;

            jump_addr_o = 32'b0;
            jump_en_o	= 1'b0;
            hold_flag_o = 1'b0;
        end
    endcase
end



endmodule