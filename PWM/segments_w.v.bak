module segments_w(
    input  [9:0] SW,
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX3
);

    BCD_4displays #(.N_in(10), .N_out(7)) WRAP (
        .bcd_in   (SW),
        .D_un     (HEX0),
        .D_de     (HEX1),
        .D_cen    (HEX2),
        .D_un_mi  (HEX3)
    );

endmodule