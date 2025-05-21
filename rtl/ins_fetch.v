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

	input wire          jump_en_i,
    input wire          hold_flag_i,
	input wire  		jump_addr_i,
	// to if_id
	output wire[31:0] inst_addr_o, 
	output wire[31:0] inst_o
	);


	// assign if2rom_addr_o = pc_addr_i;
	
	// assign inst_addr_o  = pc_addr_i;
	
	// assign inst_o = rom_inst_i;

	wire [31:0] inst_addr_temp;



	reg [31:0] rom_inst_reg;
	reg [31:0] rom_inst_reg2;
	reg [31:0] rom_inst_reg3;
	reg [3:0] 	hold_state;
	reg 	   hold_flag_reg;
	reg 	   hold_flag_reg2;
	// reg [31:0] rom_inst_temp;
	reg  	   jump_en_reg;

	// assign rom_inst_temp = hold_flag_reg ? rom_inst_reg : rom_inst_i;

		dff_set 
	#(.DW(6'd32))
	addr_1(
		.clk      (clk      ),
		.rst      (rst      ),
		.set_data (32'b0 ),
		.data_i   (pc_addr_i   ),

		.jump_en_i(jump_en_i),
		.hold_flag_i(hold_flag_i),
		.data_o   (inst_addr_temp   )
	);

		dff_set 
	#(.DW(6'd32))
	addr_2(
		.clk      (clk      ),
		.rst      (rst      ),
		.set_data (32'b0 ),
		.data_i   (inst_addr_temp   ),

		.jump_en_i(jump_en_i),
		.hold_flag_i(hold_flag_i),
		.data_o   (inst_addr_o   )
	);


	always @(posedge clk or  posedge rst) begin
		if (rst) begin
			hold_flag_reg <= 1'b0;
			rom_inst_reg <= 32'b0;
			rom_inst_reg2 <= 32'b0;
			rom_inst_reg3 <= 32'b0;
			jump_en_reg <= 1'b0;
			hold_flag_reg2 <= 1'b0;
		end
		else begin
			hold_flag_reg <= hold_flag_i;
			hold_flag_reg2 <= hold_flag_reg;

			rom_inst_reg <= rom_inst_i;
			rom_inst_reg2 <= rom_inst_reg;
			rom_inst_reg3 <= rom_inst_reg2;
			jump_en_reg <= jump_en_i;
		end
		
	end

	wire [31:0] ins_dff_o;

	dff_set 
	#(.DW(6'd32))
	ins(
		.clk      (clk      ),
		.rst      (rst      ),
		.set_data (`INST_NOP ),
		.data_i   (rom_inst_i   ),
		.jump_en_i(jump_en_i),
		.hold_flag_i(hold_flag_i),
		.data_o   (ins_dff_o   )
	);

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			hold_state[3:1] <= 3'b0;
		end
		else begin
			hold_state[1] <= hold_state[0];
			hold_state[2] <= hold_state[1];
			hold_state[3] <= hold_state[2];
		end
	end

	always @(*) begin
		hold_state[0] = hold_flag_i;
	end

	// assign inst_o = (~hold_flag_reg2)? ins_dff_o:
	// 				(~hold_flag_i)? rom_inst_reg2: rom_inst_reg2;

	assign inst_o = (hold_state == 4'b0000)? ins_dff_o:
					(hold_state == 4'b0001)? ins_dff_o:
					(hold_state == 4'b0100)? rom_inst_reg2:
					(hold_state == 4'b0101)? rom_inst_reg2:
					(hold_state == 4'b1010)? rom_inst_reg3:
					ins_dff_o;
	
	



endmodule