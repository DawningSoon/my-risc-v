`timescale 1ns/1ps

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
wire [31:0]x15= tb.u_top.u_regs.regs[15];

wire  [31:0] haddr;
wire  [2:0] hsize;
wire [31:0] hwdata;
wire        hwrite;
wire  [1:0] htrans;
wire [31:0]  hrdata;
wire hready;

wire [31:0] haddr_s;
wire [2:0]  hsize_s;
wire [31:0] hwdata_s;
wire        hwrite_s;
// reg[31:0]  hrdata_s1;
wire[31:0]  hrdata_s1;
reg        hready_s1;
wire         hsel_s1;



initial begin

    // $readmemh("E:/file/my-risc-v/sim/inst_txt/rv32um-p-divu.txt",tb.u_rom.rom_mem);     //烧录指令
	// $readmemh("E:/file/my-risc-v/sim/test.txt",tb.u_rom.rom_mem);
    clk = 1;
    rst = 1;
    // inst = `INST_NOP;

    #100;
    rst = 0;

	hready_s1 = 1;


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
		
		#20;
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

always @(*) begin
	$display("%s",x15);
end

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
	.inst_addr_o (inst_addr ),

	.haddr       (haddr       ),
	.hsize       (hsize       ),
	.htrans      (htrans      ),
	.hwdata      (hwdata      ),
	.hwrite      (hwrite      ),
	.hrdata      (hrdata      ),
	.hready      (hready      )
);

ahb_bridge u_ahb_bridge(
	.hclk      (clk      ),
	.hreset_n  (~rst  ),
	.haddr_m   (haddr   ),
	.hsize_m   (hsize   ),
	.hwdata_m  (hwdata  ),
	.hwrite_m  (hwrite  ),
	.htrans_m  (htrans  ),
	.hrdata_m  (hrdata  ),
	.hready_m  (hready  ),
	.haddr_s   (haddr_s   ),
	.hsize_s   (hsize_s   ),
	.hwdata_s  (hwdata_s  ),
	.hwrite_s  (hwrite_s  ),
	.hrdata_s1 (hrdata_s1 ),
	.hready_s1 (hready_s1 ),
	.hsel_s1   (hsel_s1   )
	// .hrdata_s2 (hrdata_s2 ),
	// .hready_s2 (hready_s2 ),
	// .hsel_s2   (hsel_s2   ),
	// .hrdata_s3 (hrdata_s3 ),
	// .hready_s3 (hready_s3 ),
	// .hsel_s3   (hsel_s3   ),
	// .hrdata_s4 (hrdata_s4 ),
	// .hready_s4 (hready_s4 ),
	// .hsel_s4   (hsel_s4   )
);


// rom u_rom(
//     .rom_addr_i (inst_addr ),
//     .rom_o      (inst      )
// );

reg [31:0] bram_addr;
reg [3:0] 	web;
reg [31:0] dinb;

always @(posedge clk ) begin
    bram_addr <= haddr_s;
    web <= {hwrite_s && hsize_s==3'd4, hwrite_s && hsize_s>=3'd3, hwrite_s && hsize_s>=3'd2 ,hwrite_s};
    // dinb <= hwdata_s;
end

bram_4k rom_ram (
  .clka(clk),    // input wire clka
  .wea(4'b0),      // input wire [3 : 0] wea
  .addra(inst_addr),  // input wire [31 : 0] addra
  .dina(32'b0),    // input wire [31 : 0] dina
  .douta(inst),  // output wire [31 : 0] douta

  .clkb(clk),    // input wire clkb
  .enb(hsel_s1),      // input wire enb
  .web(web),      // input wire [3 : 0] web
  .addrb(bram_addr),  // input wire [31 : 0] addrb
  .dinb(hwdata_s),    // input wire [31 : 0] dinb
  .doutb(hrdata_s1)  // output wire [31 : 0] doutb
);


    
endmodule