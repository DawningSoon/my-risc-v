module ahb_bridge (
    input wire hclk,
    input wire hreset_n,

    input wire [31:0] haddr_m,
    input wire [2:0]  hsize_m,
    input wire [31:0] hwdata_m,
    input wire        hwrite_m,
    input wire  [1:0]      htrans_m,

    output reg [31:0] hrdata_m,
    output reg        hready_m,

    output wire [31:0] haddr_s,
    output wire [2:0]  hsize_s,
    output wire [31:0] hwdata_s,
    output wire        hwrite_s,

    input wire [31:0]  hrdata_s1,
    input wire         hready_s1,
    output wire         hsel_s1,

    input wire [31:0]  hrdata_s2,
    input wire         hready_s2,
    output wire         hsel_s2,

    input wire [31:0]  hrdata_s3,
    input wire         hready_s3,
    output wire         hsel_s3,

    input wire [31:0]  hrdata_s4,
    input wire         hready_s4,
    output wire         hsel_s4
);

reg [3:0] hsel;

reg [3:0] hsel_reg;
reg [1:0] htrans_reg;
reg [31:0] haddr_reg;

assign haddr_s = (htrans_m == 2'b10)?haddr_m :haddr_s;
assign hsize_s = (htrans_m == 2'b10)?hsize_m : hsize_s;
assign hwdata_s = hwdata_m;
assign hwrite_s = hwrite_m;

assign {hsel_s4, hsel_s3, hsel_s2, hsel_s1} = hsel;

always @(*) begin
    if(~hreset_n)begin
        hsel = 4'b0;
        // hrdata_m = 32'b0;
        // hready_m = 1'b0;
    end
    else begin
        if (htrans_m == 2'b10) begin
            case (haddr_m[29:28])
                2'b00: begin
                    hsel = 4'b0001;
                    // hrdata_m = hrdata_s1;
                    // hready_m = hready_s1;
                end 
                2'b01: begin
                    hsel = 4'b0010;
                    // hrdata_m = hrdata_s2;
                    // hready_m = hready_s2;
                end 
                2'b10: begin
                    hsel = 4'b0100;
                    // hrdata_m = hrdata_s3;
                    // hready_m = hready_s3;
                end 
                2'b11: begin
                    hsel = 4'b1000;
                    // hrdata_m = hrdata_s4;
                    // hready_m = hready_s4;
                end 
                default: hsel = 4'b0;
            endcase
        end
    end
end

always @(*) begin
    if(~hreset_n)begin
        // hsel = 4'b0;
        hrdata_m = 32'b0;
        hready_m = 1'b0;
    end
    else begin
        if (htrans_reg == 2'b10) begin
            case (haddr_reg[29:28])
                2'b00: begin
                    // hsel = 4'b0001;
                    hrdata_m = hrdata_s1;
                    hready_m = hready_s1;
                end 
                2'b01: begin
                    // hsel = 4'b0001;
                    hrdata_m = hrdata_s2;
                    hready_m = hready_s2;
                end 
                2'b10: begin
                    // hsel = 4'b0100;
                    hrdata_m = hrdata_s3;
                    hready_m = hready_s3;
                end 
                2'b11: begin
                    // hsel = 4'b1000;
                    hrdata_m = hrdata_s4;
                    hready_m = hready_s4;
                end 
                default: begin
                    hrdata_m = 32'h0;
                    hready_m = 1'b1;

                end
            endcase
        end
    end
end

always @(posedge hclk or negedge hreset_n) begin
    if(~hreset_n)begin
        hsel_reg <= 4'b0;
        htrans_reg <= 2'b0;
        haddr_reg <= 32'b0;
    end
    else begin
        hsel_reg <= hsel;
        htrans_reg <= htrans_m;
        haddr_reg <= haddr_m;
    end
    
end
    

    
endmodule