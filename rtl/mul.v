`include "ins_defines.v"

module mul (
    input rst,

    input wire [31:0]   op1,
    input wire [31:0]   op2,
    input wire [2:0]    func3,
    input wire          mul_en,

    output reg [31:0]  op1_mul_op2_o,
    output reg [31:0]  op1_mul_op2_h_o

);

reg signed [63:0]      op1_reg;
reg signed [63:0]      op2_reg;

reg             cal;

//ALU
wire [63:0]     op1_mul_op2;


wire [63:0]     op1_extend;
wire [63:0]     op2_extend;

assign op1_extend = {{32{op1[31]}}, op1};
assign op2_extend = {{32{op2[31]}}, op2};

assign op1_mul_op2 = op1_reg * op2_reg;



always @(*) begin
    if(mul_en)begin
        if(op1_reg != op1 || op2_reg != op2)begin
            cal = 1'b1;
        end
        else cal = 1'b0;
    end
    else cal = 1'b0;
end

always @(*) begin
    if(rst)begin
        op1_reg = 64'b0;
        op2_reg = 64'b0;
    end
    else if(cal)begin
        case (func3)
            `INST_MUL: begin
                op1_reg = {32'h0, op1};
                op2_reg = {32'h0, op2};
            end
            `INST_MULH: begin
                op1_reg = op1_extend;
                op2_reg = op2_extend;
            end
            `INST_MULHSU: begin
                op1_reg = op1_extend;
                op2_reg = {32'h0, op2};
            end
            `INST_MULHU: begin
                op1_reg = {32'h0, op1};
                op2_reg = {32'h0, op2};
            end
            default: begin
                op1_reg = op1_reg;
                op2_reg = op2_reg;
            end
        endcase
        


    end
    op1_mul_op2_o = op1_mul_op2[31:0];
    op1_mul_op2_h_o = op1_mul_op2[63:32];
end
    
endmodule