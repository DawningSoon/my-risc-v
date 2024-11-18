module ld (
    input               clk,
    input               rst,

    input wire [31:0]   ins_i,
    input wire [31:0]   ins_addr_i,

    // input wire [4:0]    rs1_addr_i,
    // input wire [4:0]    rs2_addr_i,
    input wire [31:0]   rs1_data_i,
    input wire [31:0]   rs2_data_i,

    output wire [31:0]   ins_o,
    output wire [31:0]   ins_addr_o,

    output wire [31:0]   rs1_data_o,
    output wire [31:0]   rs2_data_o


);

dff_set 
#(.DW(6'd32))
ins(
    .clk      (clk      ),
    .rst      (rst      ),
    .set_data (32'b0 ),
    .data_i   (ins_i   ),
    .data_o   (ins_o   )
);

dff_set 
#(.DW(6'd32))
ins_addr(
    .clk      (clk      ),
    .rst      (rst      ),
    .set_data (32'b0 ),
    .data_i   (ins_addr_i   ),
    .data_o   (ins_addr_o   )
);

dff_set 
#(.DW(6'd32))
rs1_data(
    .clk      (clk      ),
    .rst      (rst      ),
    .set_data (32'b0 ),
    .data_i   (rs1_data_i   ),
    .data_o   (rs1_data_o   )
);

dff_set 
#(.DW(6'd32))
rs2_data(
    .clk      (clk      ),
    .rst      (rst      ),
    .set_data (32'b0 ),
    .data_i   (rs2_data_i   ),
    .data_o   (rs2_data_o   )
);


    
endmodule