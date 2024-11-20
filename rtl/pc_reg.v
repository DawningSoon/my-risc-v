module pc_reg (
    input wire          clk,
    input wire          rst,
    input wire [31:0]   jump_addr_i,
    input wire          jump_en_i,
    input wire          hold_flag_i,

    output reg [31:0]   pc
);

always @(posedge clk) begin
    if(rst == 1'b1)begin
        pc <= 32'b0;
    end
    else begin
        if(hold_flag_i)begin
            if(jump_en_i)begin
                pc <= jump_addr_i;
            end
            else pc <=pc;
        end
        else pc <= pc + 3'd4;
        
    end
    
end
    
endmodule