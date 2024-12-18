`timescale 1ns/1ps

module div_test (
    input clk,
    input rst,
    input wire [7:0] dividend_i,
    input wire [7:0] divisor_i,
    input wire div_en,
    input wire signed_i,

    output reg [7:0] output_o,
    output reg [7:0] rem_o,
    output reg wd_en
);

// reg [15:0] dividend_temp;
reg [16:0] divisor_temp;
reg [16:0] rem_temp;
reg [8:0] output_temp;

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;

wire [7:0] dividend_abs;
wire [7:0] divisor_abs;

assign dividend_abs = dividend_reg[7]? (~dividend_reg+1): dividend_reg;
assign divisor_abs = divisor_reg[7]? (~divisor_reg +1): divisor_reg;


reg [3:0] round;

reg [2:0] state;
reg [2:0] next_state;
localparam IDLE     = 3'b000;
localparam START    = 3'b001;
localparam CALC     = 3'b010;
localparam FIN      = 3'b100;

reg cal;
reg [1:0] inv;
reg signed_reg;

always @(posedge clk or rst) begin
    if(rst) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end

always @(*) begin
    if(rst)begin
        next_state = IDLE;
    end
    else begin
        case (state)
            IDLE: begin
                if(div_en) next_state = cal? START: FIN;
                else next_state = IDLE;
                // next_state =  div_en? START: IDLE;
            end
            START: next_state = cal? CALC: FIN;
            CALC: next_state = (round >= 4'd7)? FIN: CALC;
            FIN: next_state = div_en? START: IDLE;
            default: next_state = next_state;
        endcase
    end
end

always @(posedge clk or rst) begin
    if(rst)begin
        cal = 1;
    end
    else begin
        if (next_state == START) begin
            if(dividend_i == dividend_reg &&
               divisor_i == divisor_reg &&
               signed_i == signed_reg)
                cal = 0;
            else cal = 1'b1;
        end
        
    end
end

always @(*) begin   //start
    if(rst)begin
        // dividend_temp = 0;
        divisor_temp = 0;
        rem_temp = 0;
        round = 0;
        // output_temp = 0;
        rem_o = 0;
        inv = 0;
        signed_reg = 0;
        cal = 1;
    end
    else begin
        if(state == START)begin
            // rem_o = 0;
            // rem_temp = 0;
            // output_o = 0;
            round = 0;
            wd_en = 0;
            // if(dividend_i == dividend_reg &&
            //     divisor_i == divisor_reg &&
            //     signed_i == signed_reg)
            //         cal = 0;
            //     else cal = 1'b1;
            signed_reg = signed_i;
            
            dividend_reg = dividend_i;
            divisor_reg = divisor_i;
            // if(dividend_i[7]) 
            //     rem_temp ={8'h00,(~dividend_i +1)};
            // else 
            //     rem_temp ={8'h00,dividend_i};
            // if(divisor_i[7]) 
            //     divisor_temp ={(~divisor_i +1),8'h00};
            // else 
            //     divisor_temp ={divisor_i,8'h00};
            if(signed_reg)begin
                inv = {dividend_i[7] , divisor_i[7]};
                rem_temp ={9'h00,dividend_abs};
                divisor_temp ={1'b0, divisor_abs,8'h00};
            end
            else begin
                inv = 2'b0;
                rem_temp ={9'h00,dividend_reg};
                divisor_temp ={1'b0, divisor_reg,8'h00};
            end
            // inv = {dividend_i[7] , divisor_i[7]};
            // rem_temp ={9'h00,dividend_abs};
            // divisor_temp ={1'b0, divisor_abs,8'h00};
            rem_temp = rem_temp - divisor_temp;
            divisor_temp = divisor_temp >>1;
        end
    end
end

// always @(*) begin
always @(posedge clk or rst) begin
     if(rst)begin
        // dividend_temp <= 0;
        divisor_temp <= 0;
        rem_temp <= 0;
        round <= 0;
        output_temp <= 0;
        rem_o <= 0;
        // inv <= 0;
    end
    else begin
        if(state == CALC)begin
            // if(round == 0)begin
            //     rem_temp = rem_temp - divisor_temp;
            //     divisor_temp = divisor_temp >>1;
            // end
            if (round < 4'd8) begin
                
                if(rem_temp <= 17'h0_ffff) begin
                    rem_temp <= rem_temp - divisor_temp;
                    output_temp[8-round] <= 1;
                end
                
                else begin
                    rem_temp <= rem_temp + divisor_temp;
                    output_temp[8-round] <= 0;
                    
                end
                divisor_temp <= divisor_temp >>1;
                round <= round +1;
                // dividend_temp <= rem_temp;
            end
        end
    end
end

always @(*) begin
    if(rst)begin
        output_o = 0;
        rem_o = 0;
        wd_en = 0;
    end
    else if(state == FIN)begin
        if(cal) begin
            output_temp[0] = rem_temp[16]? 0: 1;
            rem_temp = rem_temp[16]? (rem_temp+divisor_abs): rem_temp;
            case (inv)
                2'b00: begin
                    output_o = output_temp;
                    rem_o = rem_temp;
                end
                2'b01: begin
                    output_o = ~output_temp +1;
                    rem_o = rem_temp;
                end
                2'b10: begin
                    output_o = ~output_temp;
                    rem_o = divisor_abs - rem_temp;
                end
                2'b11: begin
                    output_o = output_temp +1;
                    rem_o = divisor_abs - rem_temp;
                end
                default: begin
                    output_o = 0;
                    rem_o = 0;
                end
            endcase 
        end


        wd_en = 1'b1;
       
        
        // output_o = inv? ~output_temp +1: output_temp;

        // rem_o = rem_temp[7]? (rem_temp[7:0]+divisor_abs): rem_temp[7:0] ;
    end
end
    
endmodule