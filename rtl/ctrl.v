module ctrl (
    input wire  [31:0]  jump_addr_i,
    input wire  	    jump_en_i,
	input wire 	        hold_flag_i,

    output reg [31:0]   jump_addr_o,
    output reg   	    jump_en_o,
	output reg  	    hold_flag_o
);

always @(*) begin
    jump_addr_o = jump_addr_i;
    jump_en_o = jump_en_i;
    hold_flag_o = hold_flag_i;

end
    
endmodule