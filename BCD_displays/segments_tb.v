module segments_tb ();
    reg [3:0] bcd_in;
    wire [6:0] bcd_out;

    segments dut (
        .bcd_in(bcd_in),
        .bcd_out(bcd_out)
    );

    initial begin
        repeat (16) begin
            bcd_in = $random % 16;
            #10;
        end
        $stop;
        $finish;
        $display("Terminado"); 
    end

initial begin
    $monitor("bcd_in: %b, bcd_out: %b", bcd_in, bcd_out);
end

initial begin
    $dumpfile("segments_tb.vcd");
    $dumpvars(0, segments_tb);
end
endmodule