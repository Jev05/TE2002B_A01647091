module bcd_w(
    input [3:0] SW,
    output reg [0:6] HEX0
);
bcd WRAP(
    .bcd_in(SW),
    .bcd_out(HEX0)
);
endmodule