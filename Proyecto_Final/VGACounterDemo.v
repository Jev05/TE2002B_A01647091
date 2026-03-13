module VGACounterDemo(
    input clkkk,
    input [15:0] grados_x,
    input [15:0] grados_y,
    input [15:0] grados_z,
    input selector,
    input sync,
    input [2:0] guardado,
    input save,
    input [15:0] cronometro_x, cronometro_y, cronometro_z, cronometro_g,
    output reg [2:0] pixel,
    output hsync_out,
    output vsync_out

);

//-------------------------------------------------
// Señales VGA
//-------------------------------------------------

wire inDisplayArea;
wire [9:0] CounterX;
wire [9:0] CounterY;

//-------------------------------------------------
// Pixel clock 25 MHz
//-------------------------------------------------

reg pixel_tick = 0;

always @(posedge clkkk)
    pixel_tick <= ~pixel_tick;

//-------------------------------------------------
// Generador VGA
//-------------------------------------------------

hvsync_generator hvsync(
    .clk(clkkk),
    .pixel_tick(pixel_tick),
    .vga_h_sync(hsync_out),
    .vga_v_sync(vsync_out),
    .CounterX(CounterX),
    .CounterY(CounterY),
    .inDisplayArea(inDisplayArea)
);

//-------------------------------------------------
// Conversión de grados_x a dígitos
//-------------------------------------------------

wire [3:0] dx0, dx1, dx2;
wire [3:0] dy0, dy1, dy2;
wire [3:0] dz0, dz1, dz2;
wire [3:0] cronometro_x0, cronometro_x1, cronometro_x2, cronometro_x3;
wire [3:0] cronometro_y0, cronometro_y1, cronometro_y2, cronometro_y3;
wire [3:0] cronometro_z0, cronometro_z1, cronometro_z2, cronometro_z3;
wire [3:0] cronometro_g0, cronometro_g1, cronometro_g2, cronometro_g3;

assign dx0 = grados_x % 10;
assign dx1 = (grados_x / 10) % 10;
assign dx2 = (grados_x / 100) % 10;

assign dy0 = grados_y % 10;
assign dy1 = (grados_y / 10) % 10;
assign dy2 = (grados_y / 100) % 10;

assign dz0 = grados_z % 10;
assign dz1 = (grados_z / 10) % 10;
assign dz2 = (grados_z / 100) % 10;

assign cronometro_x0 = cronometro_x % 10;
assign cronometro_x1 = (cronometro_x / 10) % 10;
assign cronometro_x2 = (cronometro_x / 100) % 10;
assign cronometro_x3 = (cronometro_x / 1000) % 10;

assign cronometro_y0 = cronometro_y % 10;
assign cronometro_y1 = (cronometro_y / 10) % 10;
assign cronometro_y2 = (cronometro_y / 100) % 10;
assign cronometro_y3 = (cronometro_y / 1000) % 10;

assign cronometro_z0 = cronometro_z % 10;
assign cronometro_z1 = (cronometro_z / 10) % 10;
assign cronometro_z2 = (cronometro_z / 100) % 10;
assign cronometro_z3 = (cronometro_z / 1000) % 10;

assign cronometro_g0 = cronometro_g % 10;
assign cronometro_g1 = (cronometro_g / 10) % 10;
assign cronometro_g2 = (cronometro_g / 100) % 10;
assign cronometro_g3 = (cronometro_g / 1000) % 10;

//-------------------------------------------------
// Posición del texto
// Cada fila ocupa 16px de alto, separadas por 20px
// Cada char ocupa 8px de ancho
// Formato: "x: xxx" = 6 chars = 48px de ancho
//-------------------------------------------------

parameter X_START = 100;
parameter Y_START_X = 80;   
parameter Y_START_Y = 100;   
parameter Y_START_Z = 120;   
parameter Y_START_selector = 140;   // fila para imprimir automático o manual dependiendo 1 o 0 del selector
parameter Y_START_sync = 160;   // fila para imprimir síncrono o asíncrono dependiendo 1 o 0 del sync
parameter X_CRONOMETRO = 180; // posición horizontal del cronómetro
parameter Y_CRONOMETRO = 200;  // posición vertical del cronómetro
parameter Z_CRONOMETRO = 220;  // separación vertical entre cronómetros
parameter G_CRONOMETRO = 240;  // separación vertical entre cronómetros


//-------------------------------------------------
// Detectar en qué fila estamos
//-------------------------------------------------

wire in_row_x, in_row_y, in_row_z, in_row_selector, in_row_sync, in_row_cronometro_x, in_row_cronometro_y, in_row_cronometro_z, in_row_cronometro_g;

assign in_row_x = (CounterY >= Y_START_X) && (CounterY < Y_START_X + 16);
assign in_row_y = (CounterY >= Y_START_Y) && (CounterY < Y_START_Y + 16);
assign in_row_z = (CounterY >= Y_START_Z) && (CounterY < Y_START_Z + 16);
assign in_row_selector = (CounterY >= Y_START_selector) && (CounterY < Y_START_selector + 16);
assign in_row_sync = (CounterY >= Y_START_sync) && (CounterY < Y_START_sync + 16);
assign in_row_cronometro_x = (CounterY >= X_CRONOMETRO) && (CounterY < X_CRONOMETRO + 16);
assign in_row_cronometro_y = (CounterY >= Y_CRONOMETRO) && (CounterY < Y_CRONOMETRO + 16);
assign in_row_cronometro_z = (CounterY >= Z_CRONOMETRO) && (CounterY < Z_CRONOMETRO + 16);
assign in_row_cronometro_g = (CounterY >= G_CRONOMETRO) && (CounterY < G_CRONOMETRO + 16);

wire in_any_row;
assign in_any_row = in_row_x | in_row_y | in_row_z | in_row_selector | in_row_sync | in_row_cronometro_x | in_row_cronometro_y | in_row_cronometro_z | in_row_cronometro_g;

//-------------------------------------------------
// Pixel dentro del caracter
//-------------------------------------------------

wire [2:0] col;
wire [3:0] row_pix;

assign col     = CounterX - X_START;
assign row_pix = in_row_x        ? (CounterY - Y_START_X)        :
                 in_row_y        ? (CounterY - Y_START_Y)        :
                 in_row_z        ? (CounterY - Y_START_Z)        :
                 in_row_selector ? (CounterY - Y_START_selector) :
                 in_row_sync     ? (CounterY - Y_START_sync)     :
                 in_row_cronometro_x ? (CounterY - X_CRONOMETRO) :
                 in_row_cronometro_y ? (CounterY - Y_CRONOMETRO) :
                 in_row_cronometro_z ? (CounterY - Z_CRONOMETRO) :
                 (CounterY - G_CRONOMETRO);

wire [4:0] char_index;   
assign char_index = (CounterX - X_START) >> 3;

//---------------------
// Selección del ASCII 
//---------------------

reg [7:0] ascii;

always @* begin
    if (in_row_x) begin
        case(char_index)
            4'd0: ascii = "x";
            4'd1: ascii = ":";
            4'd2: ascii = " ";
            4'd3: ascii = dx2 + "0";
            4'd4: ascii = dx1 + "0";
            4'd5: ascii = dx0 + "0";
            4'd6: ascii = " ";
            4'd7: begin
                if (guardado[2] == 1'b1)
                    ascii = "a";
                else begin
                    ascii = "b";
                end
            end
            4'd8: begin
                if (guardado[2] == 1'b1)
                    ascii = "c";
                else
                    ascii = "l";
            end
            4'd9: begin
                if (guardado[2] == 1'b1)
                    ascii = "t";
                else
                    ascii = "k";
            end
            default: ascii = " ";
        endcase
    end
    else if (in_row_y) begin
        case(char_index)
            4'd0: ascii = "y";
            4'd1: ascii = ":";
            4'd2: ascii = " ";
            4'd3: ascii = dy2 + "0";
            4'd4: ascii = dy1 + "0";
            4'd5: ascii = dy0 + "0";
            4'd7: begin
                if (guardado[1] == 1'b1)
                    ascii = "a";
                else begin
                    ascii = "b";
                end
            end
            4'd8: begin
                if (guardado[1] == 1'b1)
                    ascii = "c";
                else
                    ascii = "l";
            end
            4'd9: begin
                if (guardado[1] == 1'b1)
                    ascii = "t";
                else
                    ascii = "k";
            end
            default: ascii = " ";
        endcase
    end
    else if (in_row_z) begin
        case(char_index)
            4'd0: ascii = "z";
            4'd1: ascii = ":";
            4'd2: ascii = " ";
            4'd3: ascii = dz2 + "0";
            4'd4: ascii = dz1 + "0";
            4'd5: ascii = dz0 + "0";
            4'd7: begin
                if (guardado[0] == 1'b1)
                    ascii = "a";
                else begin
                    ascii = "b";
                end
            end
            4'd8: begin
                if (guardado[0] == 1'b1)
                    ascii = "c";
                else
                    ascii = "l";
            end
            4'd9: begin
                if (guardado[0] == 1'b1)
                    ascii = "t";
                else
                    ascii = "k";
            end
            default: ascii = " ";
        endcase
    end
    else if (in_row_selector) begin
        // selector=0 manual    (6 chars)
        // selector=1 automatico (10 chars)
        if (~selector) begin
            case(char_index)
                4'd0: ascii = "m";
                4'd1: ascii = "a";
                4'd2: ascii = "n";
                4'd3: ascii = "u";
                4'd4: ascii = "a";
                4'd5: ascii = "l";
                default: ascii = " ";
            endcase
        end
        else begin
            case(char_index)
                4'd0: ascii = "a";
                4'd1: ascii = "u";
                4'd2: ascii = "t";
                4'd3: ascii = "o";
                4'd4: ascii = "m";
                4'd5: ascii = "a";
                4'd6: ascii = "t";
                4'd7: ascii = "i";
                4'd8: ascii = "c";
                4'd9: ascii = "o";
                default: ascii = " ";
            endcase
        end
    end
    else if (in_row_sync) begin 
        // sync=1 sincrono   (8 chars)
        // sync=0 asincrono  (9 chars)
        if (sync) begin
            case(char_index)
                4'd0: ascii = "s";
                4'd1: ascii = "i";
                4'd2: ascii = "n";
                4'd3: ascii = "c";
                4'd4: ascii = "r";
                4'd5: ascii = "o";
                4'd6: ascii = "n";
                4'd7: ascii = "o";
                default: ascii = " ";
            endcase
        end
        else begin
            case(char_index)
                4'd0: ascii = "a";
                4'd1: ascii = "s";
                4'd2: ascii = "i";
                4'd3: ascii = "n";
                4'd4: ascii = "c";
                4'd5: ascii = "r";
                4'd6: ascii = "o";
                4'd7: ascii = "n";
                4'd8: ascii = "o";
                default: ascii = " ";
            endcase
        end
    end
    else if (in_row_cronometro_x) begin
        if(~save && guardado[2]) begin
            case(char_index)
                4'd0: ascii = "s";
                4'd1: ascii = "a";
                4'd2: ascii = "v";
                4'd3: ascii = "e";
                4'd4: ascii = "_";
                4'd5: ascii = "x";
                4'd6: ascii = ":";
                4'd7: ascii = cronometro_x2 + "0";
                4'd8: ascii = cronometro_x1 + "0"; 
                4'd9: ascii = cronometro_x0 + "0";
                default: ascii = " ";
            endcase
        end
    end
    else if (in_row_cronometro_y) begin
        if(~save && guardado[1]) begin
            case(char_index)
                4'd0: ascii = "s";
                4'd1: ascii = "a";
                4'd2: ascii = "v";
                4'd3: ascii = "e";
                4'd4: ascii = "_";
                4'd5: ascii = "y";
                4'd6: ascii = ":";
                4'd7: ascii = cronometro_y2 + "0";
                4'd8: ascii = cronometro_y1 + "0"; 
                4'd9: ascii = cronometro_y0 + "0";
                default: ascii = " ";
            endcase  
        end
    end
    else if (in_row_cronometro_z) begin
        if(~save && guardado[0]) begin
            case(char_index)
                4'd0: ascii = "s";
                4'd1: ascii = "a";
                4'd2: ascii = "v";
                4'd3: ascii = "e";
                4'd4: ascii = "_";
                4'd5: ascii = "z";
                4'd6: ascii = ":";
                4'd7: ascii = cronometro_z2 + "0";
                4'd8: ascii = cronometro_z1 + "0"; 
                4'd9: ascii = cronometro_z0 + "0";
                default: ascii = " ";
            endcase  
        end
    end
    else begin
        if(~save) begin
            case(char_index)
                4'd0: ascii = "s";
                4'd1: ascii = "a";
                4'd2: ascii = "v";
                4'd3: ascii = "e";
                4'd4: ascii = "_";
                4'd5: ascii = "g";
                4'd6: ascii = ":";
                4'd7: ascii = cronometro_g2 + "0";
                4'd8: ascii = cronometro_g1 + "0"; 
                4'd9: ascii = cronometro_g0 + "0";
                default: ascii = " ";
            endcase  
        end
    end
end
//-------------------------------------------------
// Dirección ROM
//-------------------------------------------------

wire [10:0] rom_addr;
assign rom_addr = (ascii << 4) + row_pix;

//-------------------------------------------------
// ROM fuente
//-------------------------------------------------

wire [7:0] font_row;

font_rom font(
    .addr(rom_addr),
    .data(font_row)
);

//-------------------------------------------------
// Pixel activo
//-------------------------------------------------

wire pixel_on;
assign pixel_on = font_row[7 - col];

//-------------------------------------------------
// Dibujo
//-------------------------------------------------

always @(posedge clkkk) begin
    if (inDisplayArea) begin
        if (CounterX >= X_START && CounterX < X_START + 80 && in_any_row) begin
            if (pixel_on)
                pixel <= 3'b111;
            else
                pixel <= 3'b000;
        end
        else
            pixel <= 3'b000;
    end
    else
        pixel <= 3'b000;
end

endmodule