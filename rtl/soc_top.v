module top (
    input wire          clk,
    input wire          rst,
    input wire [31:0]   inst_i,
    output wire [31:0]  inst_addr_o
);

wire [31:0]     pc_reg_pc_o;    //pc to if

assign pc_reg_pc_o = inst_addr_o;   //从外部rom获取指令

wire [31:0]     if_id_ins_addr;     //if to id
wire [31:0]     if_id_ins;

wire [31:0]     id_ex_ins;      //id to ex/regs
wire [31:0]     id_ex_ins_addr;
wire [4:0]     id_ex_rs1_addr;
wire [4:0]     id_ex_rs2_addr;

wire [4:0]     reg_ex_rs1_addr;     //reg to ex
wire [4:0]     reg_ex_rs2_addr;
wire [31:0]     reg_ex_rs1_data;
wire [31:0]     reg_ex_rs2_data;


assign reg_ex_rs1_addr = id_ex_rs1_addr;
assign reg_ex_rs2_addr = id_ex_rs2_addr;

ex u_ex(
    .ins_i      (ins_i      ),
    .ins_addr_i (ins_addr_i ),
    .ins_o      (ins_o      ),
    .ins_addr_o (ins_addr_o ),
    .rs1_data_i (rs1_data_i ),
    .rs2_data_i (rs2_data_i ),
    .rd_addr_o  (rd_addr_o  ),
    .rd_data_o  (rd_data_o  ),
    .rd_wr_en   (rd_wr_en   )
);




regs u_regs(
    .clk        (clk        ),
    .rst        (rst        ),
    .rs1_addr_i (id_ex_rs1_addr ),
    .rs2_addr_i (id_ex_rs2_addr ),
    .rs1_data_o (reg_ex_rs1_data ),
    .rs2_data_o (reg_ex_rs2_data ),
    .wr_en      (wr_en      ),
    .rd_addr_i  (rd_addr_i  ),
    .rd_data_i  (rd_data_i  ),
    .rd_data_o  (rd_data_o  )
);


decode u_decode(
    .ins_i      (if_id_ins      ),
    .ins_addr_i (if_id_ins_addr ),
    .ins_o      (id_ex_ins      ),
    .ins_addr_o (id_ex_ins_addr ),
    .rs1_addr_o (id_ex_rs1_addr ),
    .rs2_addr_o (id_ex_rs2_addr )
    // .rd_addr_o  (rd_addr_o  )
    // .imm_o      (imm_o      )
);



ins_fetch u_ins_fetch(
    .pc_addr_i     (pc_reg_pc_o     ),
    .rom_inst_i    (inst_i    ),
    // .if2rom_addr_o (if2rom_addr_o ),
    .inst_addr_o   (if_id_ins_addr   ),
    .inst_o        (if_id_ins        )
);




pc_reg u_pc_reg(
    .clk (clk ),
    .rst (rst ),
    .pc  (pc_reg_pc_o  )
);

    
endmodule