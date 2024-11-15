module rom(
	input wire[31:0] rom_addr_i,
	output reg[31:0] rom_o
);

	reg[31:0] rom_mem[0:4095];  //4096 个 32b的 空间  //错
	
	always @(*)begin
		rom_o = rom_mem[rom_addr_i>>2];
	end

endmodule