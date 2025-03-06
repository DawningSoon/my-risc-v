`timescale 1ns/1ps

module ahb_tb ();

    reg hclk;
    reg hreset_n;    
    wire [31:0] hrdata;
    wire        hready;
    reg [31:0] ram_addr_i;
    reg        ram_rd_en;
    reg [2:0]  ram_size_i;
    reg        ram_wd_en;
    reg  [31:0] ram_wd_data;

    wire [31:0] ram_rd_data;       
    wire        ram_ready;
    wire  [31:0] haddr;
    wire  [2:0] hsize;
    wire [31:0] hwdata;
    wire        hwrite;
    wire  [1:0]      htrans;

    wire [31:0] haddr_s;
    wire [2:0]  hsize_s;
    wire [31:0] hwdata_s;
    wire        hwrite_s;
    // reg[31:0]  hrdata_s1;
    wire[31:0]  hrdata_s1;
    reg        hready_s1;
    wire         hsel_s1;
    reg [31:0]  hrdata_s2;
    reg         hready_s2;
    wire         hsel_s2;

    reg [31:0]  hrdata_s3;
    reg         hready_s3;
    wire         hsel_s3;
   reg [31:0]  hrdata_s4;
   reg         hready_s4;
   wire         hsel_s4;

    initial begin
        hclk = 1;
        #1;
        hreset_n = 0;
        // haddr = 32'b0;

        
        // hrdata_s1 = 32'h0;
        hready_s1 = 0;
        ram_addr_i = 32'h0;
        ram_rd_en = 0;
        ram_size_i = 3'd4;
        ram_wd_data = 32'h0;

        ram_wd_en = 0;


        #100;
        hreset_n = 1;
        ram_wd_data = 32'h00001111;
        ram_addr_i = 32'h0;
        ram_wd_en = 1;

        #10;
        ram_wd_data = 32'h00002222;
        hready_s1 = 1;

        ram_addr_i = 32'h0000_0004;
        ram_wd_en = 1;
        

        #10;
        ram_wd_data = 32'h00001111;
        hready_s1 = 1;
        ram_wd_en = 0;

        ram_addr_i = 32'h0000_0000;
        ram_rd_en = 1;
        // hready = 0;

        #10;
        hrdata_s3 = 32'h0f0f_0f0f;
        hready_s1 =1;

        ram_addr_i = 32'h0000_0004;
        ram_rd_en = 1;
        // ram_rd_en = 0;
        

        #10;
        hrdata_s4 = 32'hf0f0_f0f0;
        hready_s1 =1;

        #10;
        
        hready_s4 = 0;

        



        
    end


    always #5 hclk = ~hclk;

ahb_master u_ahb_master(
            .hclk        (hclk        ),
            .hreset_n    (hreset_n    ),
            .haddr       (haddr       ),
            .hsize       (hsize       ),
            .htrans      (htrans      ),
            .hwdata      (hwdata      ),
            .hwrite      (hwrite      ),
            .hrdata      (hrdata      ),
            .hready      (hready      ),
            .ram_addr_i  (ram_addr_i  ),
            .ram_rd_en   (ram_rd_en   ),
            .ram_size_i  (ram_size_i  ),
            .ram_rd_data (ram_rd_data ),
            .ram_wd_en   (ram_wd_en   ),
            .ram_wd_data (ram_wd_data ),
            .ram_ready   (ram_ready   )
        );


ahb_bridge u_ahb_bridge(
    .hclk      (hclk      ),
    .hreset_n  (hreset_n  ),
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
reg [3:0] web;
reg [31:0] dinb;

always @(posedge hclk ) begin
    bram_addr <= haddr_s;
    web <= {hwrite_s, hwrite_s, hwrite_s,hwrite_s};
    // dinb <= hwdata_s;
end
        
bram_4k rom_ram (
  .clka(hclk),    // input wire clka
  .wea(4'b0),      // input wire [3 : 0] wea
  .addra(haddr_s),  // input wire [31 : 0] addra
  .dina(32'b0),    // input wire [31 : 0] dina
//   .douta(hrdata_s1),  // output wire [31 : 0] douta

  .clkb(hclk),    // input wire clkb
  .enb(hsel_s1),      // input wire enb
  .web(web),      // input wire [3 : 0] web
  .addrb(bram_addr),  // input wire [31 : 0] addrb
  .dinb(hwdata_s),    // input wire [31 : 0] dinb
  .doutb(hrdata_s1)  // output wire [31 : 0] doutb
);


    
endmodule