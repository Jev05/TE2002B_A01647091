module BCD_4displays #(parameter N_in = 10, N_out = 7)(
	
	input [N_in-1:0] bcd_in,
	
	output [N_out-1:0] D_un,D_de,D_cen,D_un_mi
	);
	
	wire [3:0] unidades, decenas, centenas, millares;
	
	assign unidades = bcd_in % 10;
	
	assign decenas = (bcd_in / 10) % 10;
	
	assign centenas = (bcd_in / 100) % 10;
	
	assign millares = (bcd_in / 1000) % 10;
	
	
	segments unidadess (
		.bcd_in(unidades),
		.bcd_out(D_un)
	);

	segments decenass (
		.bcd_in(decenas),
		.bcd_out(D_de)
	);

	segments centenass (
		.bcd_in(centenas),
		.bcd_out(D_cen)
	);

	segments millaress (
		.bcd_in(millares),
		.bcd_out(D_un_mi)
	);
	
endmodule