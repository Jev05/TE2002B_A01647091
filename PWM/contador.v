module contador #(parameter N = 8, C_MAX = 100_000)(
    input clk,
    input rst,                      
    output reg [N-1:0] count
);

    always @(posedge clk or negedge rst) begin 
        if (!rst)                              
            count <= 0;
        else if (count >= C_MAX - 1)
            count <= 0;
        else
            count <= count + 1;
    end
endmodule