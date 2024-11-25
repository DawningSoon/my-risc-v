`include "ins_defines.v"

module decode (

    input wire [31:0] ins_i,
    input wire [31:0] ins_addr_i,

    output reg [31:0] ins_o,
    output reg [31:0] ins_addr_o,

    output reg [4:0]    rs1_addr_o,
    output reg [4:0]    rs2_addr_o
    // output reg [4:0]    rd_addr_o,
    // output reg [31:0]   imm_o
    
);

    wire [6:0]      opcode;
    wire [4:0]      rs1;
    wire [4:0]      rs2;
    // wire [4:0]      rd;
    wire [2:0]      func3;
    wire [6:0]      func7;
    // wire [31:0]     imm;

    assign opcode = ins_i[6:0];
    // assign rd 	  = ins_i[11:7];
    assign func3  = ins_i[14:12];
    assign rs1 	  = ins_i[19:15];
    assign rs2 	  = ins_i[24:20];
    assign func7  = ins_i[31:25];


    always @(*) begin
        ins_o = ins_i;
        ins_addr_o = ins_addr_i;

        case (opcode)
            `INST_TYPE_I: begin     //I type instructions
                rs1_addr_o = rs1;
                rs2_addr_o = `x0;
            end
            `INST_TYPE_R_M:begin    //R&M type instructions
                rs1_addr_o = rs1;
                rs2_addr_o = rs2;
            end
            `INST_TYPE_B: begin     //B type
                rs1_addr_o = rs1;
                rs2_addr_o = rs2;
            end
            `INST_TYPE_S:begin      //S type
                rs1_addr_o = rs1;
                rs2_addr_o = rs2;
            end
            `INST_JALR: begin       //jalr
                rs1_addr_o = rs1;
                rs2_addr_o = `x0;
            end
            `INST_TYPE_L: begin
                
            end
            `INST_TYPE_S: begin
                rs1_addr_o = rs1;
                rs2_addr_o = rs2;
            end
            default: begin
                rs1_addr_o = `x0;
                rs2_addr_o = `x0;
            end
        endcase

        
    end
    
endmodule