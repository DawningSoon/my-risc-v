

`include "../rtl/ins_defines.v"

module tb (
    
);
reg             clk;
reg             rst;

reg[31:0] rom_mem[0:4095];

wire [31:0]      inst;
wire [31:0]     inst_addr;

wire [31:0]x3 = tb.u_top.u_regs.regs[3];
wire [31:0]x26= tb.u_top.u_regs.regs[26];
wire [31:0]x27= tb.u_top.u_regs.regs[27];



initial begin

    $readmemh("E:/file/my-risc-v/sim/inst_txt/rv32ui-p-srli.txt",tb.u_rom.rom_mem);     //烧录指令

    clk = 0;
    rst = 1;
    // inst = `INST_NOP;

    #100
    rst = 0;


end

integer r;
	initial begin
/* 		while(1)begin
			@(posedge clk) 
			$display("x27 register value is %d",tb.open_risc_v_soc_inst.open_risc_v_inst.regs_inst.regs[27]);
			$display("x28 register value is %d",tb.open_risc_v_soc_inst.open_risc_v_inst.regs_inst.regs[28]);
			$display("x29 register value is %d",tb.open_risc_v_soc_inst.open_risc_v_inst.regs_inst.regs[29]);
			$display("---------------------------");
			$display("---------------------------");
		end */
		wait(x26 == 32'b1);
		
		#200;
		if(x27 == 32'b1) begin
			$display("############################");
			$display("########  pass  !!!#########");
			$display("############################");
		end
		else begin
			$display("############################");
			$display("########  fail  !!!#########");
			$display("############################");
			$display("fail testnum = %2d", x3);
            end
	end

always #5 clk = ~clk;

// always @(*) begin
//     case(inst_addr[3:2])
//         2'b00: inst <= {12'd2, 5'd0, `INST_ADDI, 5'd10, `INST_TYPE_I};      //x10 = 2
//         2'b01: inst <= {12'd1, 5'd11, `INST_ADDI, 5'd11, `INST_TYPE_I};     //x11 = x11 +1
//         2'b10: inst <= {7'b0000000, `x10, `x11, `INST_ADD_SUB, `x12, `INST_TYPE_R_M};     //x12 = x11+x10
//         2'b11: inst <= {7'b0100000, `x10, `x12, `INST_ADD_SUB, `x13, `INST_TYPE_R_M};   //x13 = x12 - x10
        
        
//     endcase
// end

top u_top(
    .clk         (clk         ),
    .rst         (rst         ),
    .inst_i      (inst      ),
    .inst_addr_o (inst_addr )
);

rom u_rom(
    .rom_addr_i (inst_addr ),
    .rom_o      (inst      )
);


    
endmodule