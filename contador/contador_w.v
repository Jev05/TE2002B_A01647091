module contador_w(
    input        MAX10_CLK1_50,
    input  [1:0] KEY,
	 input  [7:0] SW,
    output [0:0] LEDR,
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX3
	 
);
    wire clk_1hz;
    wire [6:0] count_val;

    
    clk_div #(.FREQ(1)) DIV (
        .clk     (MAX10_CLK1_50),
        .rst     (KEY),
        .clk_divi(clk_1hz)
    );

    assign LEDR = clk_1hz;

    
    contador #(.N(7)) CONT (
        .clk  (clk_1hz),
        .rst  (KEY[0]),
        .count(count_val),
		  .updown (SW[0]),
		  .load (KEY[1]),
		  .data_in(SW[7:1])
    );

    
    BCD_4displays #(.N_in(7), .N_out(7)) DISP (
        .bcd_in  (count_val),
        .D_un    (HEX0),
        .D_de    (HEX1),
        .D_cen   (HEX2),
        .D_un_mi (HEX3)
    );

endmodule