`include "ins_defines.v"

module div (
    input clk,
    input rst,

    input wire [31:0]   op1,
    input wire [31:0]   op2,
    input wire [2:0]    func3,
    input wire          div_en,

    output reg [31:0]   op1_div_op2,
    output reg [31:0]   op1_div_op2_rem,

    output reg          busy,
    output reg          ready,
    output reg          wd_en
);

reg [2:0]   func3_reg;
reg         cal;
reg [31:0]  op1_reg;
reg [31:0]  op2_reg;

reg [3:0]   state;
localparam IDLE     = 4'b0000;
localparam START    = 4'b0001;
localparam CALC     = 4'b0100;
localparam FIN      = 4'b1000;



reg         neg;

//ALU
wire [31:0] op1_invert = ~op1 +1;
wire [31:0] op2_invert = ~op2 +1;

always @(*) begin
    if (div_en) begin
        if (op1_reg == op1 && op2_reg == op2 
            && func3_reg[2] == func3[2] && func3_reg[0] == func3[0]) begin
            cal = 1'b0;
        end
        else cal = 1'b1;
    end
    else cal = 1'b0;
end

always @(*) begin
    if(rst)begin
        op1_reg = 32'b0;
        op2_reg = 32'b0;
        func3_reg = 3'b000;
    end
    else if(div_en)begin
        func3_reg = func3;
        case (func3)
            `INST_DIV, `INST_REM: begin
                neg = op1[31] != op2[31];
                op1_reg = op1[31]? op1_invert: op1;
                op2_reg = op2[31]? op2_invert: op2;
            end
            `INST_DIVU, `INST_REMU: begin
                op1_reg = op1;
                op2_reg = op2;
            end
            default: begin
                
            end
        endcase
    end
end

reg [31:0]   rem_temp;
reg [31:0]   dividend_temp;
reg [31:0]   divisor_temp;

always @(posedge clk) begin
    
end
    
endmodule