`timescale 1ns / 1ps

module admin_mem_tb;

    parameter DATA_WIDTH = 17;
    parameter ADDR_WIDTH = 7;
    parameter FREQ_SIM = 5; 

    reg save, rst, clk, en_x, en_y, en_z, selector;
    reg [15:0] in_x, in_y, in_z;
    wire [DATA_WIDTH-1:0] data_ox;
    admin_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .FREQ(FREQ_SIM)
    ) dut (
        .save(save), .rst(rst), .clk(clk), 
        .en_x(en_x), .en_y(en_y), .en_z(en_z), 
        .selector(selector),
        .in_x(in_x), .in_y(in_y), .in_z(in_z),
        .data_ox(data_ox)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0; rst = 0; save = 1; selector = 0;
        en_x = 1; in_x = 16'h0000;
        
        #100 rst = 0;
        #100 rst = 1;
        #100;

        
        $display(">>> Grabando Posicion AAAA en Addr 0...");
        in_x = 16'hAAAA;
        #20 save = 0;
        #(20 * FREQ_SIM * 3); 
        $display(">>> Soltando: Guardando Tiempo en Addr 1...");
        save = 1;
        #200; 
        $display(">>> Grabando Posicion BBBB en Addr 2...");
        in_x = 16'hBBBB;
        #20 save = 0;
        #(20 * FREQ_SIM * 5); 
        $display(">>> Soltando: Guardando Tiempo en Addr 3...");
        save = 1;
        #200;
        $display(">>> Iniciando Reproduccion (Bucle)...");
        selector = 1;
        
        #(20 * FREQ_SIM * 25);

        $display(">>> Simulacion terminada.");
        $finish;
    end
	 
    initial begin
        $monitor("T=%t | Sel=%b | Save=%b | Addr=%d | WriteState=%d | DataOut=%b_%h | WaitCnt=%d", 
                 $time, selector, save, dut.addr_x, dut.state_write, data_ox[16], data_ox[15:0], dut.delay_counter_x);
    end

endmodule