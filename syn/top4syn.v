module syn_top (
    input clk,
    input rst,


     input wire[31:0]   hrdata_s2,
     input wire         hready_s2,
     output wire        hsel_s2,

     input wire[31:0]   hrdata_s3,
     input wire         hready_s3,
     output wire        hsel_s3,

     input wire[31:0]   hrdata_s4,
     input wire         hready_s4,
     output wire        hsel_s4
);

wire [31:0]      inst;
wire [31:0]     inst_addr;

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

wire[31:0]  hrdata_s1;
wire        hready_s1;
wire         hsel_s1;


(*keep_hierachy = "True"*)
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


(*keep_hierachy = "True"*)
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
	.hsel_s1   (hsel_s1   ),
	.hrdata_s2 (hrdata_s2 ),
	.hready_s2 (hready_s2 ),
	.hsel_s2   (hsel_s2   ),
	.hrdata_s3 (hrdata_s3 ),
	.hready_s3 (hready_s3 ),
	.hsel_s3   (hsel_s3   ),
	.hrdata_s4 (hrdata_s4 ),
	.hready_s4 (hready_s4 ),
	.hsel_s4   (hsel_s4   )
);

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