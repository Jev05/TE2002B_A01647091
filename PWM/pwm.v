module pwm #(parameter frecuencia_servo = 50, frecuencia_clk = 5_000_000, dutyMin = 1, dutyMax = 12)(
    input        clk, rst,
    input  [7:0] SW,
	 output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX3,
	 output reg pwm
);

   reg [7:0] grados;
	
	localparam MAX_COUNT = frecuencia_clk / frecuencia_servo;
	localparam FUNCION = ceillog2(MAX_COUNT);
	
	localparam m = (((dutyMax * MAX_COUNT / 100) - (dutyMin * MAX_COUNT / 75))) / 180;
	localparam b = (dutyMin * MAX_COUNT) / 75;

    wire [FUNCION-1:0] pwm_count;
	 
    contador #(.N(FUNCION), .C_MAX(MAX_COUNT)) CONT_SERVO (
        .clk  (clk),
        .rst  (rst),
        .count(pwm_count)
    );
	 
	  BCD_4displays #(.N_in(8), .N_out(7)) DISP (
    .bcd_in  (grados),
    .D_un    (HEX0),
    .D_de    (HEX1),
    .D_cen   (HEX2),
    .D_un_mi (HEX3)
);

always @(posedge clk or negedge rst) begin
		if(rst==0) begin
			pwm=0;
		end
		else begin
			if(SW>180)
				grados=180;
			else
				grados=SW;
			if(pwm_count<((m*grados)+b))
				pwm=1;
			else
				pwm=0;
		end
	end
	
	
	 
	 function integer ceillog2;
     input integer data;
     integer i,result;
		  begin
			 for(i=0; 2**i < data; i=i+1)
				 result = i + 1;
			 ceillog2 = result;
		  end
    endfunction
	 
	 
	 
endmodule