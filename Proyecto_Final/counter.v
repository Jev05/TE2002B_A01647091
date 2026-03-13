module counter #(parameter max_count = 100, n=8)(
    input clk, 
    input rst,
    output reg [(n-1):0] count
);
	 reg updown = 1;

    always @(posedge clk or negedge rst) begin  
        if (rst == 1'b0) begin
            count         	<= 8'b0;
        end
		  
		  else begin
			  if (updown) begin
					if (count >= max_count)
						updown = ~updown;
					else 
						count <= count + 1'b1;
			  end 
			  else begin
					if (count == 8'b0)
						 updown = ~updown;
					else
						 count <= count - 1'b1;
			  end
        end
    end
endmodule