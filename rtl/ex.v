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
    output reg        rd_wr_en
);

wire[6:0] opcode; 
wire[4:0] rd; 
wire[2:0] func3; 
wire[4:0] rs1;
wire[4:0] rs2;
wire[6:0] func7;
wire[11:0]imm;

assign opcode = ins_i[6:0];
assign rd 	  = ins_i[11:7];
assign func3  = ins_i[14:12];
assign rs1 	  = ins_i[19:15];
assign rs2 	  = ins_i[24:20];
assign func7  = ins_i[31:25];
assign imm    = ins_i[31:20];

always @(*) begin
    case (opcode)
        `INST_TYPE_I:begin
            case(func3)
                `INST_ADDI:begin
                    rd_data_o = rs1_data_i + imm;
                    rd_addr_o = rd;
                    rd_wr_en  = 1'b1;
                end
                default:begin
                    rd_data_o = 32'b0;
                    rd_addr_o = 5'b0;
                    rd_wr_en  = 1'b0;
                end
            endcase
        end
        `INST_TYPE_R_M: begin
            case(func3)
                `INST_ADD_SUB: begin
                    if(func7 == 7'b000_0000)begin//add
                        rd_data_o = rs1_data_i + rs2_data_i;
                        rd_addr_o = rd;
                        rd_wr_en = 1'b1;
                    end
                    else begin
                        rd_data_o = rs1_data_i - rs2_data_i;
                        rd_addr_o = rd;
                        rd_wr_en = 1'b1;
                    end
                end
                default:begin
                    rd_data_o = 32'b0;
                    rd_addr_o = 5'b0;
                    rd_wr_en  = 1'b0;
                end
            endcase
        end
        default: begin
            rd_data_o = 32'b0;
            rd_addr_o = 5'b0;
            rd_wr_en  = 1'b0;
        end
    endcase
end

endmodule