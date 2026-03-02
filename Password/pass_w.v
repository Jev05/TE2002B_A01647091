module pass_w(
    input [3:0] SW,
    input [1:0] KEY,        // KEY[0]=load , KEY[1]=reset
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX3
);

parameter S0=0, S1=1, S2=2, S3=3, OK=4, ERR=5;

reg [2:0] state, nextstate;
reg [15:0] pass = 16'h1234;
reg [0:27] display;   
wire [0:6] aux;       

wire btn   = KEY[0];
wire rst   = KEY[1];


segments seg0(
    .bcd_in(SW),
    .bcd_out(aux)
);


assign {HEX3, HEX2, HEX1, HEX0} = display;


always @(*) begin
    nextstate = state;
    
    case(state)
        S0: if(SW==pass[15:12]) nextstate=S1; else nextstate=ERR;
        S1: if(SW==pass[11:8]) nextstate=S2; else nextstate=ERR;
        S2: if(SW==pass[7:4]) nextstate=S3; else nextstate=ERR;
        S3: if(SW==pass[3:0]) nextstate=OK; else nextstate=ERR;
        OK:  nextstate=OK;
        ERR: nextstate=ERR;
    endcase
end


always @(negedge btn or negedge rst) begin

    if (rst == 0) begin
        state   <= S0;
        display <= ~28'b0;  
    end 
    else begin
    
        
        if (state == OK) begin
            display <= ~28'b1111011_0011101_0011101_0111101;
        end
        
        else if (state == ERR) begin
            display <= ~28'b0000000_0011111_1110111_0111101; 
        end
        else begin
            
            if (nextstate == ERR) begin
                state   <= ERR;
                display <= ~28'b0000000_0011111_1110111_0111101;  
            end
            
            
            else begin
                display[7:27] <= display[0:20];
                display[0:6]  <= aux;
                state         <= nextstate;
            end
            
        end
    end
end

endmodule