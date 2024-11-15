module regs (
    input wire [4:0]    reg_addr,
    input wire          wr_en,
    input wire [31:0]   reg_data_i,
    output wire [31:0]  reg_data_o
);

reg [31:0] regs[0:31];

assign reg_data_o = regs[reg_addr];

always @(*) begin
    if (wr_en == 1'b1) begin
        regs[reg_addr] = reg_data_i;
    end
end
    
endmodule