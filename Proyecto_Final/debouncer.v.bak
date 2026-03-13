module debouncer #(parameter regis=4)(
	input clk, btn, rst,
	output reg btn_db, btn_db_pk
	);
	reg cam;
	initial begin
		cam<=0;
		btn_db_pk<=0;
	end
	
	wire [regis-1:0] checker;
	genvar i;
	ffd ff1(.d(!btn), .clk(clk), .rst(rst), .q(checker[0]));
	
	generate
		for(i=1; i<regis; i=i+1) begin : ff
			ffd ffx(.d(checker[i-1]), .clk(clk), .rst(rst), .q(checker[i]));
		end
	endgenerate 
	
	always @(posedge clk) begin
		if (&checker) begin
			btn_db=1;
			end
		else begin
			btn_db<=0;
			end
			
		if (&checker != cam) begin
			btn_db_pk<=1;
			cam <= &checker;
			end
		else begin
			btn_db_pk<=0;
			end
	end
endmodule