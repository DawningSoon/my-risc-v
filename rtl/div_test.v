`timescale 1ns/1ps

module div_test (
    input clk,
    input rst,
    input wire [7:0] dividend_i,
    input wire [7:0] divisor_i,
    input wire div_en,

    output reg [7:0] output_o,
    output reg [7:0] rem_o
);

reg [15:0] dividend_temp;
reg [15:0] divisor_temp;
reg [15:0] rem_temp;

reg [3:0] round;

reg [2:0] state;
localparam IDLE     = 3'b000;
localparam START    = 3'b001;
localparam CALC     = 3'b010;
localparam FIN      = 3'b100;

reg cal;
reg inv;

always @(posedge clk or rst) begin
    if(rst) begin
        state <= IDLE;
    end
    else begin
        case (state)
            IDLE: state <= div_en? START: IDLE; 
            START: state <= CALC;
            CALC: state <= (round == 4'd8)? FIN: CALC;
            FIN: state <= IDLE;
            default: state <= state;
        endcase
    end
end

always @(*) begin   //start
    if(rst)begin
        dividend_temp = 0;
        divisor_temp = 0;
        rem_temp = 0;
        round = 0;
        output_o = 0;
        rem_o = 0;
        inv = 0;
    end
    else begin
        if(state == START)begin
            rem_o = 0;
            rem_temp = 0;
            output_o = 0;
            round = 0;
            inv = dividend_i[7] == divisor_i[7];
            if(dividend_i[7]) dividend_temp ={8'h00,(~dividend_i +1)};
            else dividend_temp ={8'h00,dividend_i};
            if(divisor_i[7]) divisor_temp ={(~divisor_i +1),8'h00};
            else divisor_temp ={divisor_i,8'h00};
            rem_temp = dividend_temp - divisor_temp;
            divisor_temp = divisor_temp >>1;
        end
    end
end

always @(posedge clk) begin
     if(rst)begin
        dividend_temp <= 0;
        divisor_temp <= 0;
        rem_temp <= 0;
        round <= 0;
        output_o <= 0;
        rem_o <= 0;
        inv <= 0;
    end
    else begin
        if(state == CALC)begin
            if (round < 4'd8) begin
                
                if(rem_temp <= 8'b0111_1111) begin
                    rem_temp <= rem_temp - divisor_temp;
                    output_o[8-round] <= 1;
                end
                
                else begin
                    rem_temp <= rem_temp + divisor_temp;
                    output_o[8-round] <= 0;
                    
                end
                divisor_temp <= divisor_temp >>1;
                round <= round +1;
                // dividend_temp <= rem_temp;
            end
        end
    end
end

always @(*) begin
    if(state == FIN)begin
        if(inv)begin
            
        end
        rem_o = rem_temp[7]? (rem_temp[7:0]+divisor_i): rem_temp[7:0] ;
        output_o[0] = rem_temp[7]? 0: 1;
    end
end
    
endmodule