module axi_bus (
    input wire          aclk,
    input wire          arst,

    //master addr read
    // input wire [3:0]    m_ar_id,
    input wire [31:0]   m_ar_addr,
    input wire          m_ar_valid,
    input wire [3:0]    m_ar_size,
    output reg         m_ar_ready,

    //master data read
    // output reg [3:0]   m_rd_id,
    output reg [31:0]  m_rd_data,
    output reg         m_rd_valid,
    input wire          m_rd_ready,

    //master addr write
    // input wire [3:0]    m_aw_id,
    input wire [31:0]   m_aw_addr,
    input wire          m_aw_valid,
    input wire [3:0]    m_aw_size,
    output reg         m_aw_ready,

    //master data write
    // input wire [3:0]    m_wd_id,
    input wire [31:0]   m_wd_data,
    input wire          m_wd_valid,
    output reg         m_wd_ready,

    //master response
    // output reg [3:0]    m_b_id,
    output reg          m_b_valid,
    output reg [1:0]    m_b_resp,
    input wire          m_b_ready,


    //slave0 addr read (rom/ram)
    output reg [31:0]   s0_ar_addr,
    output reg          s0_ar_valid,
    output reg [3:0]    s0_ar_size,
    input wire         s0_ar_ready,

    //slave0 data read
    input wire [31:0]  s0_rd_data,
    input wire         s0_rd_valid,
    output reg          s0_rd_ready,

     //slave addr write
    output reg [31:0]   s0_aw_addr,
    output reg          s0_aw_valid,
    output reg [3:0]    s0_aw_size,
    input wire         s0_aw_ready,

    //slave0 data write
    output reg [31:0]   s0_wd_data,
    output reg          s0_wd_valid,
    input wire         s0_wd_ready



);

//read addr reg
wire [31:0]      ar_addr = m_ar_addr;
wire             ar_valid = m_ar_valid;
reg             ar_ready;
wire [3:0]       ar_size = m_ar_size;

//read data reg
reg [31:0]      rd_data;
reg             rd_ready;
wire             rd_valid = m_rd_valid;

//write addr reg
wire [31:0]      aw_addr = m_aw_addr;
wire             aw_valid = m_aw_valid;
reg             aw_ready;
wire [3:0]       aw_size = m_aw_size;

//write data reg
wire [31:0]      wd_data = m_wd_data;
wire             wd_valid = m_wd_valid;
reg             wd_ready;

//resp reg
wire [1:0]       resp = m_b_resp;
wire             resp_valid = m_b_valid;
wire             resp_ready = m_b_ready;


//m read addr channel
always @(*) begin
    if(ar_addr < 32'h0001_0000)begin
        ar_ready = s0_ar_ready;
        rd_data = s0_rd_data;
        rd_ready = s0_rd_ready;
    end
end


always @(aclk) begin
    if(ar_addr < 32'h0001_0000)begin
        m_ar_ready <= ar_ready;
    end
end

    
endmodule