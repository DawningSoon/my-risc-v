module dff_set #(
	parameter DW  = 6'd32
)
(
	input wire clk,
	input wire rst,
	input wire [DW-1:0]  set_data, 
	input wire [DW-1:0]  data_i,
	
	input wire          jump_en_i,
    input wire          hold_flag_i, 

	output reg [DW-1:0]  data_o	
);
	always @(posedge clk or posedge rst or posedge jump_en_i)begin
		if(rst || jump_en_i)
			data_o <= set_data;
		else begin
			if(hold_flag_i)
				data_o <= data_o;
			else
				data_o <= data_i;
		end	
	end
			

endmodule