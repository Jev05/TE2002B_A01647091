module servo_control_w(
	input [7:0] SW,
	input MAX10_CLK1_50,
	input [0:0]	KEY,
	output [0:6] HEX0, HEX1, HEX2,
	output [0:0] ARDUINO_IO
	);
	servo_control #(.frec_clk(50_000_000), .rampa(1000_000)) servo (.in(SW), .clk(MAX10_CLK1_50), .rst(KEY[0]), .display({HEX0, HEX1, HEX2}), .pwm(ARDUINO_IO));

endmodule