module contador #(parameter N = 16)(
    input clk,
    input rst, 
    input updown,
    input load,
    input [6:0] data_in,
    output reg [N-1:0] count
);

    always @(posedge clk or negedge rst)
    begin
        if (!rst) begin                      
            if (updown)
                count <= 0;                   
            else
                count <= 100;                 
        end
        else if (!load) begin                 
            count <= data_in;
        end
        else begin                            
            if (updown) begin                 
                if (count >= 100)
                    count <= 0;
                else
                    count <= count + 1;
            end
            else begin                        
                if (count == 0)
                    count <= 100;
                else
                    count <= count - 1;
            end
        end
    end

endmodule