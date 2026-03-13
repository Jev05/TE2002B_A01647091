module suma (
	input clk,
	input [3:0] numeros,
	input carga,
	input rst,
	output reg [7:0] resultado

);

reg activo;
reg [3:0] contador;

always @(posedge clk or negedge rst) begin
	if (~rst) begin
		contador <=4'd0;
		activo <= 1'b0;
		resultado <=8'd0;
		end
	else if (carga) begin
		   resultado <= 8'd0;
			contador <= numeros;
			activo <= 1'b1;
		end 
		else if (activo) begin
			if (contador > 0) begin
				resultado <= resultado + contador;
				contador <= contador - 1;
			end
		else begin
		activo <=1'b0;
	end

end
end
endmodule