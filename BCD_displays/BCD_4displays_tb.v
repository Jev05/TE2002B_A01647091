module BCD_4displays_tb #(parameter N_in = 10, N_out = 7)(
);
    reg [N_in-1:0] bcd_in;
    
    wire [N_out-1:0] D_un,D_de,D_cen,D_un_mi;
    
    
    BCD_4displays dut(
        .bcd_in(bcd_in),
        .D_un(D_un),
        .D_de(D_de),
        .D_cen(D_cen),
        .D_un_mi(D_un_mi)
    );
    
    initial begin
        repeat (1023) begin
            bcd_in = $random % 1023;
            #10;
        end
        $stop;
        $finish;
        $display("Terminado"); 
    end

    initial begin
    $monitor("bcd_in: %b, D_un: %b, D_de: %b, D_cen: %b, D_un_mi: %b", bcd_in, D_un, D_de, D_cen, D_un_mi);
end

initial begin
    $dumpfile("BCD_4displays_tb.vcd");
    $dumpvars(0, BCD_4displays_tb);
end
endmodule