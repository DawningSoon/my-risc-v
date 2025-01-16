module regs (
    input wire          clk,
    input wire          rst,

    input wire [4:0]    rs1_addr_i,
    input wire [4:0]    rs2_addr_i,

    output reg [31:0]   rs1_data_o,
    output reg [31:0]   rs2_data_o,

    input wire          wr_en,
    input wire [4:0]    rd_addr_i,
    input wire [31:0]   rd_data_i,
    output wire [31:0]  rd_data_o
);

reg [31:0] regs[0:31];
integer i;

always @(*) begin
    if(rst == 1'b1) rs1_data_o <= 32'b0;
    else begin
        if(rs1_addr_i == 5'b0) rs1_data_o <= 32'b0;
        else if(wr_en == 1'b1 && (rd_addr_i == rs1_addr_i))
            rs1_data_o <= rd_data_i;
        else rs1_data_o <= regs[rs1_addr_i];
    end 
end

always @(*) begin
    if(rst == 1'b1) rs1_data_o <= 32'b0;
    else begin
        if(rs2_addr_i == 5'b0) rs2_data_o <= 32'b0;
        else if(wr_en == 1'b1 && (rd_addr_i == rs2_addr_i))
            rs2_data_o <= rd_data_i;
        else rs2_data_o <= regs[rs2_addr_i];
    end 
end

always @(posedge clk) begin
    if(rst)begin
        for(i = 0; i<32; i=i+1)begin
            // if (i == 2) begin
            //     regs[i] <= 32'h2000;        //手动设置sp寄存器的栈顶
            // end
            // else 
            regs[i] <= 32'b0;
        end
    end
    else begin
        if(wr_en && (rd_addr_i != 5'b0))begin
            regs[rd_addr_i] <= rd_data_i;
        end
    end
end
    
endmodule