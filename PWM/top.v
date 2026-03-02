module top(
    input        MAX10_CLK1_50,
    input  [0:0] KEY,
    input  [7:0] SW,
    output [0:6] HEX0, HEX1, HEX2, HEX3,
    output [1:1] ARDUINO_IO
);

wire clk_1hz;

    clk_div #(.FREQ(5_000_000)) DIV (
        .clk     (MAX10_CLK1_50),
        .rst  (KEY[0]),
        .clk_divi(clk_1hz)
    );
	 
	 
	 



    pwm #(.frecuencia_clk(5_000_000)) servo (
        .SW 		(SW),
		  .clk		(clk_1hz),
		  .rst		(KEY[0]),
		  .HEX0    	(HEX0),
		  .HEX1    	(HEX1),
		  .HEX2 	 	(HEX2),
		  .HEX3 		(HEX3),
		  .pwm	(ARDUINO_IO)
    );
	 

endmodule