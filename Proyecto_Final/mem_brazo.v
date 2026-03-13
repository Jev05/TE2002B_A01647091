module mem_brazo #(parameter DATA_WIDTH = 17, ADDR_WIDTH = 7, FILE = "memX.hex")(
    input clk,
    input we,
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out
);

reg [DATA_WIDTH-1:0] memoria [0:(2**ADDR_WIDTH)-1];
initial begin
	if (FILE != "") begin
		$readmemh(FILE, memoria);
	end
end

always @(posedge clk) begin
	if (we) begin
		memoria[addr] <= data_in;
	end
	else
		data_out <= memoria[addr];
end

endmodule