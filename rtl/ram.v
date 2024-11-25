module ram (
    input clk,
    // input rst,

    input wire [31:0]   rd_addr_i,
    input wire          rd_en,
    input wire [2:0]    rd_size_i,
    output reg [31:0]   rd_data_o,

    input wire [31:0]   wd_addr_i,
    input wire          wd_en,
    input wire [4:0]    wd_size_i,
    input wire [31:0]   wd_data_i
);

reg[7:0] ram_mem[0:4095];  //4096 个 8b的 空间

reg [31:0] data_temp;


always @(*) begin
   
    if(rd_en)begin
        if(rd_addr_i ==wd_addr_i && wd_en)begin
            data_temp = wd_data_i;
        end
        else 
            data_temp = {ram_mem[rd_addr_i + 3], ram_mem[rd_addr_i + 2], ram_mem[rd_addr_i + 1], ram_mem[rd_addr_i]};

        case (rd_size_i)
            3'd1: begin     //8bit
                rd_data_o <= {24'h0, data_temp[7:0]};
            end
            3'd2: begin     //16bit
                rd_data_o <= {16'h0, data_temp[15:0]};
            end
            3'd4: begin     //32bit
                rd_data_o <= data_temp;
            end
            default: rd_data_o <= 32'h0;
        endcase
    end
end

always @(posedge clk) begin
    if(wd_en)begin
        case (wd_size_i)
            3'd1: begin     //8bit
                ram_mem[wd_addr_i] <= wd_data_i[7:0];
            end
            3'd2: begin     //16bit
                {ram_mem[wd_addr_i + 1], ram_mem[wd_addr_i]} <= wd_data_i[15:0];
            end
            3'd4: begin     //32bit
                {ram_mem[wd_addr_i + 3], ram_mem[wd_addr_i + 2], ram_mem[wd_addr_i + 1], ram_mem[wd_addr_i]} <= wd_data_i;
            end
            default: rd_data_o <= 32'h0;
        endcase
    end
end


    
endmodule