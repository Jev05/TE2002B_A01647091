`timescale 1ns/1ps

module pass_sw_tb;

    // Entradas
    reg [3:0] SW;
    reg [1:0] KEY;

    // Salidas
    wire [0:6] HEX0;
    wire [0:6] HEX1;
    wire [0:6] HEX2;
    wire [0:6] HEX3;

    
    pass_sw dut (
        .SW(SW),
        .KEY(KEY),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );

    
    initial begin
        
    
        SW  = 0;
        KEY = 2'b11;

        KEY[1] = 0;  #10;
        KEY[1] = 1;   #10;
        
        
        
        // Paso 1
        SW = 4'd1; #10;
        KEY[0] = 0; #10;   // presionar load
        KEY[0] = 1; #10;  // soltar
        
        // Paso 2
        SW = 4'd2; #10;
        KEY[0] = 0; #10;
        KEY[0] = 1; #10;
         
        // Paso 3
        SW = 4'd3; #10;
        KEY[0] = 0; #10;
        KEY[0] = 1; #10;
        
        // Paso 4
        SW = 4'd4; #10;
        KEY[0] = 0; #10;
        KEY[0] = 1; #10;

        #50;


//mal pass        
        KEY[1] = 0; #10; 
        KEY[1] = 1; #10;

        SW = 4'd9; #10;
        KEY[0] = 0; #10;
        KEY[0] = 1; #10;

        #50;

        $stop;
    end

    initial begin
        $monitor("Tiempo: %0t | SW: %b | KEY: %b | HEX0: %b | HEX1: %b | HEX2: %b | HEX3: %b", 
                 $time, SW, KEY, HEX0, HEX1, HEX2, HEX3);
    end
    
    initial begin
        $dumpfile("pass_sw_tb.vcd");
        $dumpvars(0, pass_sw_tb);
    end

endmodule