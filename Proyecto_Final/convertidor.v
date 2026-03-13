module convertidor #(parameter min = 0, max = 180)(
	input [15:0] data,
	input selector,
	output[15:0] grados
);

wire signo;
wire [15:0] visual;

assign signo = data [15];
assign visual = signo ? (~data + 1'b1) : data;

wire [15:0] offset;
assign offset = signo ? ( (visual > 256) ? 16'd0 : (16'd256 - visual) ) : ( 16'd256 + visual );
wire [31:0] mult = offset * max;
wire [15:0] calc = mult >> 9;

wire [15:0] grados_z;
assign grados = (calc < min)  ? min  : (calc > max) ? max : calc[15:0];

endmodule