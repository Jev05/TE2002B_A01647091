module UART_Tx_tb ();

reg clk;
reg rst;
reg [7:0] data_in;
reg start;

wire tx_out;
wire busy;

UART_Tx #(.BAUD_RATE(9600), .CLOCK_FREQ(50000000), .BITS(8)) dut (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .start(start),
    .tx_out(tx_out),
    .busy(busy)
);



initial begin
    rst = 1;
    start = 0;
    data_in = 0;
    #100;
    rst = 0;
    clk = 0;
    #20;
    clk = 1;
end

always #10 clk = ~clk;

initial begin
   $display("Inicio"); 
   #30;
   rst = 1;
   #10;
   rst = 0;
   #20;
   repeat(10) begin
        data_in = $random % 256;
        start = 1;
        #20;
        start = 0;
        wait (!busy);
        $display("Dato transmitido: %h", data_in);
        #20;
    end
    $stop;
$finish;
end

initial begin
    //files
    $dumpfile("UART_Tx_tb.vcd");
    $dumpvars(0, UART_Tx_tb);    
end



endmodule