module segments(
	input [3:0] bcd_in,
	output reg [0:6] bcd_out);
	
	always@(*)
	begin
		case (bcd_in)
		4'b0000: bcd_out = ~7'b1111110; // 0
		4'b0001: bcd_out = ~7'b0110000; // 1
		4'b0010: bcd_out = ~7'b1101101; // 2
		4'b0011: bcd_out = ~7'b1111001; // 3
		4'b0100: bcd_out = ~7'b0110011; // 4	
		4'b0101: bcd_out = ~7'b1011011; // 5
		4'b0110: bcd_out = ~7'b1011111; // 6
		4'b0111: bcd_out = ~7'b1110000; // 7
		4'b1000: bcd_out = ~7'b1111111; // 8
		4'b1001: bcd_out = ~7'b1111011; // 9
			default: bcd_out = ~7'b0000000; 
		endcase
		end
		endmodule
	