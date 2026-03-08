module UART_tb_txrx();

//Señales para el transmisor
reg clk;
reg rst;
reg [7:0] data_in;
reg start;
//wire tx_out;
wire busy;

//Señales intermedias
wire UART_wire; // Conexión entre TX y RX

//Señales para el receptor
//reg rx_in;
wire [7:0] data_out;
wire data_ready;

UART UART_inst (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .start(start),
    .tx_out(UART_wire), // Conecta la salida del transmisor a la entrada del receptor
    .busy(busy),
    .data_out(data_out),
    .data_ready(data_ready)
);


initial begin
    clk = 0;
    rst = 0;
    data_in = 8'h00;
    start = 0;
end

always
    #10 clk = ~clk; // Genera un reloj de 50 MHz

initial
begin
    $display("Simulacion iniciada");
    #30;
    rst = 1; 
    #20;        
    rst = 0; 
    #200; 

    repeat(10) begin
        @(posedge clk);        // Sincroniza con el reloj
        data_in = $random;     // Dato aleatorio
        start = 1;             // Pulso de inicio
        @(posedge clk);
        start = 0;

        // ESPERA CRÍTICA: 
        // Primero esperamos a que la bandera de la transmisión anterior baje
        // o simplemente esperamos a que el receptor termine.
        wait(data_ready == 1); 
        
        $display("Dato transmitido: %h, Dato recibido: %h", data_in, data_out);
        
        // Damos un pequeño margen para que el receptor vuelva a IDLE
        #100; 
        
        // Esperamos a que el sistema no esté ocupado antes de la siguiente iteración
        wait(!busy); 
        #500; // Espacio entre bytes
    end
    $display("Simulacion finalizada");
    $stop;
end


initial begin
   $dumpfile("UART_tb_txrx.vcd");
   $dumpvars(0, UART_tb_txrx);
end

endmodule