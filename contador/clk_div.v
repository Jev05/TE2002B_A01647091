module clk_div #(parameter FREQ = 1)(
    input  clk,
    input  rst,           
    output reg clk_divi
);
    parameter CLK_FREQ = 50_000_000;
    parameter COUNT_MAX = (CLK_FREQ / (2 * FREQ));
    reg [31:0] count;

    always @(negedge clk or negedge rst)
    begin
        if (!rst) begin
            count    <= 32'b0;
            clk_divi <= 1'b0;
        end
        else if (count == COUNT_MAX - 1) begin
            count    <= 32'b0;
            clk_divi <= ~clk_divi;
        end
        else begin
            count <= count + 1;
        end
    end
endmodule