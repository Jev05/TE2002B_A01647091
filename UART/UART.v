module UART(
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire start,
    output wire tx_out,
    output wire busy,
    output wire [7:0] data_out,
    output wire data_ready
);

wire UART_wire; // Conexión entre TX y RX

UART_Tx #(.BAUD_RATE(9600), .CLOCK_FREQ(50000000), .BITS(8)) UART_TX (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .start(start),
    .tx_out(UART_wire),
    .busy(busy)
);

UART_Rx #(.BAUD_RATE(9600), .CLOCK_FREQ(50000000), .BITS(8)) UART_RX (
    .clk(clk),
    .rst(rst),
    .rx_in(UART_wire),
    .data_out(data_out),
    .data_ready(data_ready)
);
endmodule

/*
module UART(
    input [7:0] SW,
    input [1:0] KEY,        // KEY[0]=reset, KEY[1]=start
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX3,
    output [0:0] LEDR,      // LED para busy
    output [1:1] ARDUINO_IO,      // Pin TX
    input  MAX10_CLK1_50,   
    output busy             
);


wire busy_wire;
assign LEDR[0] = busy_wire;
assign busy    = busy_wire;

UART_Tx #(
    .BAUD_RATE(9600), 
    .CLOCK_FREQ(50000000), 
    .BITS(8)
) UART_TX_INST (
    .clk(MAX10_CLK1_50),
    .rst(KEY[0]),    
    .data_in(SW),
    .start(KEY[1]),  
    .tx_out(ARDUINO_IO),
    .busy(busy_wire)
);

BCD_4displays #(
    .N_in(8),
    .N_out(7)
) DISP (
    .bcd_in  (SW),
    .D_un    (HEX0),
    .D_de    (HEX1),
    .D_cen   (HEX2),
    .D_un_mi (HEX3)
);

endmodule*/