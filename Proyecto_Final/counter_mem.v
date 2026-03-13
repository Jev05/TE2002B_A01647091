module counter_mem #(parameter max_count = 8'd100, n = 8)(
    input clk, 
    input rst, 
    input load,
    input en,
    input [n-1:0] load_bits,
    output reg [n-1:0] count
);
    always @(posedge clk or negedge rst) begin  
        if (rst == 1'b0) begin
            count         	<= 8'b0;
        end
		  
		  else begin
				case (load)
                0 : begin
                    if (en) begin
                        if (count >= max_count)
                            count <= 8'b0;
                        else 
                            count <= count + 1'b1;
                    end
						  else
								count <= count;
                end
                1 : begin
                    if (load_bits <= max_count)
                        count <= load_bits;
                    else 
                        count <= max_count; 
                end
            endcase
        end
    end
endmodule