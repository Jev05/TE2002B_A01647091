module cronometro(
    input  clk,
    input  start, 
    input  stop,
    input  rst,
    output [0:6] seguni,
    output [0:6] segde,
    output [0:6] segce,
    output [0:6] segmiseg
);

wire clk_cnt; 
clk_div #(.FREQ(100)) div ( 
    .clk(clk),
    .rst(rst),
    .clk_divi(clk_cnt)
);

reg [13:0] miliseg;
reg corriendo;

always @(posedge clk_cnt or negedge rst) begin
    if (~rst) begin
        miliseg   <= 14'b0;
        corriendo <= 1'b0;
    end else begin
        if (~start)      
            corriendo <= 1'b1;
        else if (~stop)  
            corriendo <= 1'b0;

        
        if (corriendo) begin
        
            if (miliseg >= 5999) 
                miliseg <= 14'b0; 
            else
                miliseg <= miliseg + 1'b1;
        end
    end
end

BCD_4displays WRAP (
    .bcd_in   (miliseg),
    .D_un     (seguni),    
    .D_de     (segde),
    .D_cen    (segce),
    .D_un_mi  (segmiseg)
);

endmodule