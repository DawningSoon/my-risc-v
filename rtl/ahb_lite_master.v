module ahb_master (
    input wire hclk,
    input wire hreset_n,

    output wire [31:0] haddr,
    // output reg [2:0]  hburst,
    // output reg        hmastlock,
    output wire [2:0]  hsize,
    output reg [1:0]  htrans,
    output reg [31:0] hwdata,
    output wire        hwrite,
    
    input wire [31:0] hrdata,
    input wire        hready,

    input wire [31:0] ram_addr_i,
    input wire        ram_rd_en,
    input wire [2:0]  ram_size_i,
    output reg [31:0] ram_rd_data,

    input wire        ram_wd_en,
    input wire [31:0] ram_wd_data,
    output wire       ram_ready



);

reg rd_en_temp;
reg wd_en_temp;

// reg [1:0] state;
// // reg [1:0] next_state;

// parameter idle = 2'b00;
// parameter addr = 2'b01;
// parameter data = 2'b10;

assign haddr = ram_addr_i;
assign hsize = ram_size_i;
assign hwrite = ram_wd_en;
assign ram_ready = hready && (rd_en_temp || wd_en_temp);

always @(*) begin
    if(~hreset_n) begin
        htrans = 2'b0;
    end
    else begin
        if(ram_rd_en || ram_wd_en)
            htrans = 2'b10;     //NONSEQ
        else 
            htrans = 2'b00;     //IDLE
    end
end

always @(posedge hclk or negedge hreset_n) begin
    if (~hreset_n) begin
        rd_en_temp <= 1'b0;
        wd_en_temp <= 1'b0;
    end
    else begin
         rd_en_temp <= ram_rd_en;
         wd_en_temp <= ram_wd_en;
    end
end

always @(*) begin
    if(~hreset_n) begin
        hwdata <= 32'b0;
    end
    else begin
        if(hready && wd_en_temp) begin
            case (ram_size_i)   
                3'd1: hwdata <= {24'b0, ram_wd_data[7:0]};  //8bit
                3'd2: hwdata <= {16'b0, ram_wd_data[15:0]}; //16bit
                3'd4: hwdata <= ram_wd_data;    //32bit
                default: hwdata <= 32'b0;
            endcase
        end
        else 
            hwdata <= 32'b0;
    end
end

always @(*) begin
    if(~hreset_n) begin
        ram_rd_data <= 32'b0;
    end
    else begin
        if(hready && rd_en_temp) begin
            case (ram_size_i)   
                3'd1: ram_rd_data <= {24'b0, hrdata[7:0]};  //8bit
                3'd2: ram_rd_data <= {16'b0, hrdata[15:0]}; //16bit
                3'd4: ram_rd_data <= hrdata;    //32bit
                default: ram_rd_data <= 32'b0;
            endcase
        end            
        else 
            ram_rd_data <= 32'b0;
    end
end
    
endmodule