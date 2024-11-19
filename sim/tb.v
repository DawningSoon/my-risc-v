

`include "../rtl/ins_defines.v"

module tb (
    
);
reg             clk;
reg             rst;

reg [31:0]      inst;
wire [31:0]     inst_addr;

top u_top(
    .clk         (clk         ),
    .rst         (rst         ),
    .inst_i      (inst      ),
    .inst_addr_o (inst_addr )
);

initial begin
    clk = 0;
    rst = 1;
    inst = `INST_NOP;

    #100
    rst = 0;


end

always #5 clk = ~clk;

always @(*) begin
    case(inst_addr[3:2])
        2'b00: inst <= {12'd2, 5'd0, `INST_ADDI, 5'd10, `INST_TYPE_I};      //x10 = 2
        2'b01: inst <= {12'd1, 5'd11, `INST_ADDI, 5'd11, `INST_TYPE_I};     //x11 = x11 +1
        2'b10: inst <= {7'b0000000, `x10, `x11, `INST_ADD_SUB, `x12, `INST_TYPE_R_M};     //x12 = x11+x10
        2'b11: inst <= {7'b0100000, `x10, `x12, `INST_ADD_SUB, `x13, `INST_TYPE_R_M};   //x13 = x12 - x10
        
        
    endcase
end

    
endmodule