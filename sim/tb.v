

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

    #100
    rst = 0;


end

always #5 clk = ~clk;

always @(*) begin
    case(inst_addr[3:2])
        2'b00: inst <= {12'd1, 5'd0, `INST_ADDI, 5'd10, `INST_TYPE_I};
        2'b01: inst <= {12'd2, 5'd0, `INST_ADDI, 5'd11, `INST_TYPE_I};
        2'b10: inst <= {12'd3, 5'd0, `INST_ADDI, 5'd12, `INST_TYPE_I};
        2'b11: inst <= {12'd4, 5'd0, `INST_ADDI, 5'd13, `INST_TYPE_I};
        
        
    endcase
end

    
endmodule