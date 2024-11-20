module top (
    input wire          clk,
    input wire          rst,
    input wire [31:0]   inst_i,
    output wire [31:0]  inst_addr_o
);

wire [31:0]     pc_reg_pc_o;    //pc to if



wire [31:0]     if_id_ins_addr;     //if to id
wire [31:0]     if_id_ins;

wire [31:0]     id_ld_ins;      //id to reg
wire [31:0]     id_ld_ins_addr;
wire [4:0]     id_reg_rs1_addr;
wire [4:0]     id_reg_rs2_addr;

// wire [4:0]     reg_ld_rs1_addr;     //reg to ld
// wire [4:0]     reg_ld_rs2_addr;
wire [31:0]     reg_ld_rs1_data;
wire [31:0]     reg_ld_rs2_data;

wire [31:0]     ld_ex_ins;      //ld to ex
wire [31:0]     ld_ex_ins_addr;
wire [31:0]     ld_ex_ins_rs1_data;
wire [31:0]     ld_ex_ins_rs2_data;

wire [31:0]     ex_o_ins;       //ex to reg/out
wire [31:0]     ex_o_ins_addr;
wire [4:0]      ex_rd_addr;
wire [31:0]     ex_rd_data;
wire            ex_wr_en;

wire [31:0]     ex_ctl_jump_addr;
wire            ex_ctl_jump_en;
wire            ex_ctl_hold_flag;

wire [31:0]     ctl_jump_addr;
wire            ctl_jump_en;
wire            ctl_hold_flag;

assign inst_addr_o = pc_reg_pc_o;   //从外部rom获取指令

ctrl u_ctrl(
    .jump_addr_i (ex_ctl_jump_addr ),
    .jump_en_i   (ex_ctl_jump_en   ),
    .hold_flag_i (ex_ctl_hold_flag ),
    .jump_addr_o (ctl_jump_addr ),
    .jump_en_o   (ctl_jump_en   ),
    .hold_flag_o (ctl_hold_flag )
);


ex u_ex(
    .ins_i      (ld_ex_ins      ),
    .ins_addr_i (ld_ex_ins_addr ),
    .ins_o      (ex_o_ins      ),
    .ins_addr_o (ex_o_ins_addr ),
    .rs1_data_i (ld_ex_ins_rs1_data ),
    .rs2_data_i (ld_ex_ins_rs2_data ),
    .rd_addr_o  (ex_rd_addr  ),
    .rd_data_o  (ex_rd_data  ),
    .rd_wr_en   (ex_wr_en   ),
    .jump_addr_o(ex_ctl_jump_addr),
    .jump_en_o  (ex_ctl_jump_en),
	.hold_flag_o(ex_ctl_hold_flag)
);




ld u_ld(
    .clk        (clk        ),
    .rst        (rst        ),
    .ins_i      (id_ld_ins      ),
    .ins_addr_i (id_ld_ins_addr ),
    .rs1_data_i (reg_ld_rs1_data ),
    .rs2_data_i (reg_ld_rs2_data ),
    .jump_en_i(ctl_jump_en),
    .hold_flag_i(ctl_hold_flag),
    .ins_o      (ld_ex_ins      ),
    .ins_addr_o (ld_ex_ins_addr ),
    .rs1_data_o (ld_ex_ins_rs1_data ),
    .rs2_data_o (ld_ex_ins_rs2_data )
);






regs u_regs(
    .clk        (clk        ),
    .rst        (rst        ),
    .rs1_addr_i (id_reg_rs1_addr ),
    .rs2_addr_i (id_reg_rs2_addr ),
    .rs1_data_o (reg_ld_rs1_data ),
    .rs2_data_o (reg_ld_rs2_data ),
    .wr_en      (ex_wr_en      ),
    .rd_addr_i  (ex_rd_addr  ),
    .rd_data_i  (ex_rd_data  )
    // .rd_data_o  (rd_data_o  )
);


decode u_decode(
    .ins_i      (if_id_ins      ),
    .ins_addr_i (if_id_ins_addr ),
    .ins_o      (id_ld_ins      ),
    .ins_addr_o (id_ld_ins_addr ),
    .rs1_addr_o (id_reg_rs1_addr ),
    .rs2_addr_o (id_reg_rs2_addr )
    // .rd_addr_o  (rd_addr_o  )
    // .imm_o      (imm_o      )
);



ins_fetch u_ins_fetch(
    .clk      (clk      ),
    .rst      (rst      ),
    .pc_addr_i     (pc_reg_pc_o     ),
    .rom_inst_i    (inst_i    ),
    .jump_en_i(ctl_jump_en),
    .hold_flag_i(ctl_hold_flag),
    // .if2rom_addr_o (if2rom_addr_o ),
    .inst_addr_o   (if_id_ins_addr   ),
    .inst_o        (if_id_ins        )
);




pc_reg u_pc_reg(
    .clk (clk ),
    .rst (rst ),
    .jump_addr_i(ctl_jump_addr),
    .jump_en_i(ctl_jump_en),
    .hold_flag_i(ctl_hold_flag),
    .pc  (pc_reg_pc_o  )
);

    
endmodule