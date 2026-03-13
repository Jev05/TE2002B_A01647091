module suma_w (
input MAX10_CLK1_50,
	input [3:0] SW, 
	input [1:0] KEY, //si se presiona el boton 1 de carga
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX3
);

wire [7:0] resul;

suma wrap (
	.clk(MAX10_CLK1_50),
	.numeros(SW),
	.carga(KEY[0]),
	.rst(KEY[1]),
	.resultado(resul)
);

BCD_4displays #(.N_in(10), .N_out(7)) WRAP (
        .bcd_in   (resul),
        .D_un     (HEX0),
        .D_de     (HEX1),
        .D_cen    (HEX2),
        .D_un_mi  (HEX3)
    );


endmodule