

module cronometro_w (
input MAX10_CLK1_50,
input [0:0] SW, //RESET
input [1:0] KEY, //START Y STOP
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
   output [0:6] HEX3
	 );


cronometro cuenta (
    .clk(MAX10_CLK1_50),
    .rst(SW[0]),
    .stop(KEY[0]),
    .start(KEY[1]),
    .seguni(HEX0),
    .segde(HEX1),
    .segce(HEX2),
    .segmiseg(HEX3)
);


endmodule
