module axi_bus (
    input wire          aclk,
    input wire          arst,

    //master addr read
    // input wire [3:0]    m_ar_id,
    input wire [31:0]   m_ar_addr,
    input wire          m_ar_valid,
    input wire [3:0]    m_ar_size,
    output wire         m_ar_ready,

    //master data read
    // output wire [3:0]   m_rd_id,
    output wire [31:0]  m_rd_data,
    output wire         m_rd_valid,
    input wire          m_rd_ready,

    //master addr write
    // input wire [3:0]    m_aw_id,
    input wire [31:0]   m_aw_addr,
    input wire          m_aw_valid,
    input wire [3:0]    m_aw_size,
    output wire         m_aw_ready,

    //master data write
    // input wire [3:0]    m_wd_id,
    input wire [31:0]   m_wd_data,
    input wire          m_wd_valid,
    output wire         m_wd_ready

    //master response
    // output wire [3:0]    m_b_id,
    // output wire         m_b_valid,
    // input wire          m_b_ready

    //slave0 addr read (rom/ram)

);
    
endmodule