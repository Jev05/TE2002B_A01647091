module ffd(
	input d, clk, rst,
	output reg q
	);
	
	always @(posedge clk or negedge rst) begin
		if(rst==0) q<=0;

		else q<=d;
		
	end
endmodule