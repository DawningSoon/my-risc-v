`include "ins_defines.v"

module ins_fetch(
	input wire 		clk,
	input wire  	rst,	
	//from pc
	input  wire[31:0] pc_addr_i,
	//from rom 
	input  wire[31:0] rom_inst_i,
	//to rom
	// output wire[31:0] if2rom_addr_o, 
	// to if_id
	output wire[31:0] inst_addr_o, 
	output wire[31:0] inst_o
	);


	// assign if2rom_addr_o = pc_addr_i;
	
	// assign inst_addr_o  = pc_addr_i;
	
	// assign inst_o = rom_inst_i;

	dff_set 
	#(.DW(6'd32))
	addr(
		.clk      (clk      ),
		.rst      (rst      ),
		.set_data (32'b0 ),
		.data_i   (pc_addr_i   ),
		.data_o   (inst_addr_o   )
	);

	dff_set 
	#(.DW(6'd32))
	ins(
		.clk      (clk      ),
		.rst      (rst      ),
		.set_data (`INST_NOP ),
		.data_i   (rom_inst_i   ),
		.data_o   (inst_o   )
	);
	
	



endmodule