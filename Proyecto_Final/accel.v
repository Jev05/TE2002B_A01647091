

//===========================================================================
// accel.v - Control de servo con acelerómetro DE10-Lite
//===========================================================================
module accel (
   input             ADC_CLK_10,
   input             MAX10_CLK1_50,
   input             MAX10_CLK2_50,
   //output   [0:6]    HEX0, HEX1, HEX2,
   //output   [0:6]    HEX3, HEX4, HEX5,
	output	[0:3]		ARDUINO_IO,
   input    [1:0]    KEY,
   output [9:0] LEDR,
   input [9:0] SW, 
   output [3:3] VGA_R, 
   output [3:3] VGA_G, 
   output [3:3] VGA_B, 
   output VGA_HS,
   output VGA_VS,
   output            GSENSOR_CS_N,
   input    [2:1]    GSENSOR_INT,
   output            GSENSOR_SCLK,
   inout             GSENSOR_SDI,
   inout             GSENSOR_SDO
);
	localparam SPI_CLK_FREQ = 200;
	localparam UPDATE_FREQ  = 1;
	assign LEDR[0] = SW[0];
	assign LEDR[1] = SW[1];
	assign LEDR[3] = SW[3];
	assign LEDR[4] = SW[4];
	assign LEDR[5] = SW[5];
	assign LEDR[6] = SW[6];
	assign LEDR[7] = SW[7];
	assign LEDR[8] = SW[8];
	assign LEDR[9] = SW[9];
		
	wire reset_n, clk, spi_clk, spi_clk_out;
	wire data_update;
	wire [15:0] data_x, data_y, data_z;

PLL ip_inst (
	.inclk0 (MAX10_CLK1_50),
	.c0     (clk),
	.c1     (spi_clk),
	.c2     (spi_clk_out)
);

spi_control #(
	.SPI_CLK_FREQ (SPI_CLK_FREQ),
	.UPDATE_FREQ  (UPDATE_FREQ))
spi_ctrl (
	.reset_n     (reset_n),
	.clk         (clk),
	.spi_clk     (spi_clk),
	.spi_clk_out (spi_clk_out),
	.data_update (data_update),
	.data_x      (data_x),
	.data_y      (data_y),
	.data_z      (data_z),
	.SPI_SDI     (GSENSOR_SDI),
	.SPI_SDO     (GSENSOR_SDO),
	.SPI_CSN     (GSENSOR_CS_N),
	.SPI_CLK     (GSENSOR_SCLK),
	.interrupt   (GSENSOR_INT)
);

assign reset_n = KEY[0];
wire rst_n     = reset_n;

wire clk_2_hz;
clock_divider #(.FREQ(10)) DIVISOR_REFRESH (
	.clk     (MAX10_CLK1_50),
	.rst     (rst_n),
	.clk_div (clk_2_hz)
);

reg [15:0] data_x_reg, data_y_reg, data_z_reg;
always @(posedge clk_2_hz) begin
		if(SW[9])
			data_x_reg <= data_x;
		else
			data_x_reg <= data_x_reg;
			
		if(SW[8])
			data_y_reg <= data_y;
		else
			data_y_reg <= data_y_reg;
			
		if(SW[7])
			data_z_reg <= data_z;
		else
			data_z_reg <= data_z_reg;
end

wire [7:0] garra;
reg [15:0] datos_x = 0, datos_y= 0, datos_z= 0, datos_g= 0;
wire [15:0] grados_x, grados_y, grados_z;
wire[16:0] data_ox, data_oy, data_oz, data_og;

wire selector, sync, boton_s;

wire [15:0] cronometro_x, cronometro_y, cronometro_z, cronometro_g;

debouncer #(.regis(300)) sync_sw (
	.clk(MAX10_CLK1_50), .btn(SW[0]), .rst(KEY[0]),
	.btn_db(selector)
	);

debouncer #(.regis(300)) stab_sw (
	.clk(MAX10_CLK1_50), .btn(SW[1]), .rst(KEY[0]),
	.btn_db(sync)
	);
	
debouncer #(.regis(300)) stab_sv (
	.clk(MAX10_CLK1_50), .btn(KEY[1]), .rst(KEY[0]),
	.btn_db(boton_s)
	);

admin_mem #(
    .DATA_WIDTH(17), 
    .ADDR_WIDTH(7), 
    .FREQ(50_000_000)
) memoria (
    .save(boton_s), .rst(KEY[0]), .clk(MAX10_CLK1_50), .en_x(SW[5]), .en_y(SW[4]), .en_z(SW[3]), .selector(selector), .sync(sync),
    .in_x(data_x_reg), .in_y(data_y_reg), .in_z(data_z_reg), .in_g(SW[6]),
    .data_ox(data_ox), .data_oy(data_oy), .data_oz(data_oz), .data_og(data_og),
    .cronometro_x(cronometro_x), .cronometro_y(cronometro_y), .cronometro_z(cronometro_z), .cronometro_g(cronometro_g)
);
always @(posedge MAX10_CLK1_50) begin
	if(SW[0]) begin
		if(data_ox[16]==0)
			datos_x<=data_ox[15:0];
		else
			datos_x<=datos_x;
			
		if(data_oy[16]==0)
			datos_y<=data_oy[15:0];
		else
			datos_y<=datos_y;
			
		if(data_oz[16]==0)
			datos_z<=data_oz[15:0];
		else
			datos_z<=datos_z;
		
		if(data_oz[16]==0)
			datos_z<=data_oz[15:0];
		else
			datos_z<=datos_z;
			
		if(data_og[16]==0)
			datos_g<=data_og[15:0];
		else
			datos_g<=datos_g;
	end
	else begin
		datos_x <= data_x_reg;
		datos_y <= data_y_reg;
		datos_z <= data_z_reg;
		if (SW[6])
			datos_g[0] <= 1'b1;
		else
			datos_g[0] <= 1'b0;
	end
end

convertidor #(.min(0), .max(180)) 	X (.data(datos_x), .grados(grados_x));

convertidor #(.min(0), .max(90)) 	Y (.data(datos_y), .grados(grados_y));

convertidor #(.min(90), .max(180)) 	Z (.data(datos_z), .grados(grados_z));

assign garra = (datos_g[0]) ? 52 : 34;

servo_control #(.frec_clk(50_000_000), .rampa(750_000)) servo_x (.in(grados_x), .clk(MAX10_CLK1_50), .rst(KEY[0]), .pwm(ARDUINO_IO[0]));
servo_control #(.frec_clk(50_000_000), .rampa(750_000)) servo_y (.in(grados_y), .clk(MAX10_CLK1_50), .rst(KEY[0]), .pwm(ARDUINO_IO[1]));
servo_control #(.frec_clk(50_000_000), .rampa(750_000)) servo_z (.in(grados_z), .clk(MAX10_CLK1_50), .rst(KEY[0]), .pwm(ARDUINO_IO[2]));
servo_control #(.frec_clk(50_000_000), .rampa(750_000)) servo_g (.in(garra), .clk(MAX10_CLK1_50), .rst(KEY[0]), .pwm(ARDUINO_IO[3]));



//BCD_4displays #(.bits_in(8), .displays(3)) display1 (.bcd_in(grados_x), .bcd_out({HEX0,HEX1,HEX2}));//
// BCD_4displays #(.bits_in(8), .displays(3)) display2 (.bcd_in(data_x_reg), .bcd_out({HEX3,HEX4,HEX5}));

 VGACounterDemo pantalla ( 
	.clkkk(MAX10_CLK1_50), 
	.grados_x(grados_x), 
	.grados_y(grados_y), 
	.grados_z(grados_z), 
	.cronometro_x(cronometro_x),
	.cronometro_y(cronometro_y),
	.cronometro_z(cronometro_z),
	.cronometro_g(cronometro_g),
	.save(boton_s),
	.pixel({VGA_R,VGA_G,VGA_B}), 
	.hsync_out(VGA_HS),
	.vsync_out(VGA_VS),
	.selector(selector),
	.sync(sync),
	.guardado(SW[5:3])
	);
endmodule