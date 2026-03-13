module admin_mem #(
    parameter DATA_WIDTH = 17, 
    parameter ADDR_WIDTH = 7, 
    parameter FREQ = 50_000_000
)(
    input save, rst, clk, en_x, en_y, en_z, selector, sync,
    input [15:0] in_x, in_y, in_z, in_g,
    output [DATA_WIDTH-1:0] data_ox, data_oy, data_oz, data_og, 
    output reg [DATA_WIDTH-2:0] cronometro_x = 0, cronometro_y = 0, cronometro_z = 0, cronometro_g = 0
);
    function integer ceillog2;
        input integer data;
        integer i, result;
        begin
            result = 0;
            for(i=0; 2**i < data; i=i+1) result = i + 1;
            ceillog2 = result;
        end
    endfunction

    localparam BITS_COUNT = ceillog2(FREQ);
    wire [BITS_COUNT-1:0] count_total;
    wire tick_timer = (count_total == 0);

    reg we_x, enc_x, load_x, ready_x;
    reg we_y, enc_y, load_y, ready_y;
    reg we_z, enc_z, load_z, ready_z;
    reg we_g, enc_g, load_g, ready_g;

    reg [ADDR_WIDTH-1:0] load_addr_x, load_addr_y, load_addr_z, load_addr_g;

    wire [ADDR_WIDTH-1:0] addr_x, addr_y, addr_z, addr_g;
    reg [DATA_WIDTH-1:0] reg_in_x, reg_in_y, reg_in_z, reg_in_g;


    reg [2:0] state_write_x = 0;
    reg [2:0] state_write_y = 0;
    reg [2:0] state_write_z = 0;
    reg [2:0] state_write_g = 0;

    localparam W_IDLE = 0, W_ADDR = 1, W_POS = 2, W_TIME = 3, W_WRITE_TIME = 4, W_DONE = 5;

    reg [2:0] state_read_x = 0;
    reg [2:0] state_read_y = 0;
    reg [2:0] state_read_z = 0;
    reg [2:0] state_read_g = 0;

    localparam R_LOAD_RESET = 0, R_STEP1 = 1, R_STEP2 = 2, R_CHECK = 3, R_DELAY = 4, R_SYNC = 5;

    reg [ADDR_WIDTH-1:0] ptr_escritura_x = 0;
    reg [ADDR_WIDTH-1:0] ptr_escritura_y = 0;
    reg [ADDR_WIDTH-1:0] ptr_escritura_z = 0;
    reg [ADDR_WIDTH-1:0] ptr_escritura_g = 0;

    reg [ADDR_WIDTH-1:0] last_addr_x = 0;
    reg [ADDR_WIDTH-1:0] last_addr_y = 0;
    reg [ADDR_WIDTH-1:0] last_addr_z = 0;
    reg [ADDR_WIDTH-1:0] last_addr_g = 0;
    
    reg [15:0] delay_counter_x = 0;
    reg [15:0] delay_counter_y = 0;
    reg [15:0] delay_counter_z = 0;
    reg [15:0] delay_counter_g = 0;

    reg save_ant_x, selector_ant_x, save_ant_y, selector_ant_y, save_ant_z, selector_ant_z, save_ant_g, selector_ant_g;

    mem_brazo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .FILE("memX.hex")) memX (
        .clk(clk), .we(we_x), .addr(addr_x), .data_in(reg_in_x), .data_out(data_ox)
    );
	 mem_brazo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .FILE("memY.hex")) memY (
        .clk(clk), .we(we_y), .addr(addr_y), .data_in(reg_in_y), .data_out(data_oy)
    );
	 mem_brazo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .FILE("memZ.hex")) memZ (
        .clk(clk), .we(we_z), .addr(addr_z), .data_in(reg_in_z), .data_out(data_oz)
    );
	 mem_brazo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .FILE("memG.hex")) memG (
        .clk(clk), .we(we_g), .addr(addr_g), .data_in(reg_in_g), .data_out(data_og)
    );
	 
    counter_mem #(.max_count((2**ADDR_WIDTH)-1), .n(ADDR_WIDTH)) countX (
        .clk(clk), .rst(rst), .load(load_x), .load_bits(load_addr_x), .en(enc_x), .count(addr_x)
    );
    counter_mem #(.max_count((2**ADDR_WIDTH)-1), .n(ADDR_WIDTH)) countY (
        .clk(clk), .rst(rst), .load(load_y), .load_bits(load_addr_y), .en(enc_y), .count(addr_y)
    );
	 counter_mem #(.max_count((2**ADDR_WIDTH)-1), .n(ADDR_WIDTH)) countZ (
        .clk(clk), .rst(rst), .load(load_z), .load_bits(load_addr_z), .en(enc_z), .count(addr_z)
    );
    counter_mem #(.max_count((2**ADDR_WIDTH)-1), .n(ADDR_WIDTH)) countG (
        .clk(clk), .rst(rst), .load(load_g), .load_bits(load_addr_g), .en(enc_g), .count(addr_g)
    );

    counter_rampa #(.max_count(FREQ), .n(BITS_COUNT)) timer_ref (
        .clk(clk), .rst(rst), .count(count_total)
    );

	 
	 
	 
    // -------------X----------------
    always @(posedge clk) begin
        if (rst == 0) begin
            state_write_x <= W_IDLE;
            state_read_x <= R_LOAD_RESET;
            ptr_escritura_x <= 0;
            last_addr_x <= 0;
				ready_x <= 0;
            save_ant_x <= 0;
            selector_ant_x <= 0;
            we_x <= 0; enc_x <= 0; load_x <= 0; load_addr_x <= 0;
        end 
        else begin
            save_ant_x <= save;
            selector_ant_x <= selector;
            if (!selector) begin
                state_read_x <= R_LOAD_RESET;
                case (state_write_x)
                    W_IDLE: begin
                        we_x <= 0; enc_x <= 0; load_x <= 0;
                        if (~save && save_ant_x && en_x) begin
                            load_x <= 1;
                            load_addr_x <= ptr_escritura_x;
                            state_write_x <= W_ADDR;
                        end
                    end
                    W_ADDR: begin
                        load_x <= 0;
                        we_x <= 1;
                        enc_x <= 1;
                        reg_in_x <= {1'b0, in_x};
                        cronometro_x <= 0;
                        state_write_x <= W_POS;
                    end
                    W_POS: begin
                        we_x <= 0;
                        enc_x <= 0;
                        state_write_x <= W_TIME;
                    end
                    W_TIME: begin
                        if (tick_timer && ~save) cronometro_x <= cronometro_x + 1;
                        if (save) begin
                            we_x <= 1;
                            enc_x <= 1;
                            reg_in_x <= {1'b1, cronometro_x};
                            state_write_x <= W_WRITE_TIME;
                        end
                    end
                    W_WRITE_TIME: begin
                        we_x <= 0;
                        enc_x <= 0;
                        state_write_x <= W_DONE;
                    end
                    W_DONE: begin
                        ptr_escritura_x <= addr_x;
                        last_addr_x <= addr_x;
                        state_write_x <= W_IDLE;
                    end
                endcase
            end 
            else begin
                state_write_x <= W_IDLE;
                we_x <= 0;
                
                if ((selector && !selector_ant_x) || (addr_x >= last_addr_x && last_addr_x != 0)) begin
                    load_x <= 1; 
                    load_addr_x <= 0;
                    if (sync)
                        state_read_x <= R_SYNC;
                    else
                        state_read_x <= R_LOAD_RESET;
                end
                
                else begin
                    case (state_read_x)
                        R_LOAD_RESET: begin
                            load_x <= 0;
                            if (last_addr_x != 0) begin
                                enc_x <= 0;
                                state_read_x <= R_STEP1;
								ready_x <= 0;
                            end
                            else
                                ready_x <= 1;
                            
                        end
                        R_STEP1: begin
                            enc_x <= 0;
                            state_read_x <= R_STEP2;
                        end
                        R_STEP2: begin
                            state_read_x <= R_CHECK;
                        end
                        R_CHECK: begin
                            if (data_ox[16] == 1'b0) begin 
                                enc_x <= 1;
                                state_read_x <= R_STEP1;
                            end 
                            else begin 
                                enc_x <= 0;
                                delay_counter_x <= 0;
                                state_read_x <= R_DELAY;
                            end
                        end
                        R_DELAY: begin
                            if (~selector)
                                state_read_x <= R_LOAD_RESET;
                            if (tick_timer) begin
                                if (delay_counter_x >= data_ox[15:0]) begin
                                    enc_x <= 1;
                                    state_read_x <= R_STEP1; 
                                end 
                                else begin
                                    delay_counter_x <= delay_counter_x + 1;
                                    enc_x <= 0;
                                end
                            end 
                            else enc_x <= 0;
                        end
                        R_SYNC: begin
                            ready_x <= 1;
                            if (ready_g && ready_y && ready_z) begin
                                state_read_x <= R_LOAD_RESET;
                            end
                            else begin
                                state_read_x <= R_SYNC;
                                enc_x <= 0;
                            end
                        end
                        default: begin
                            state_read_x <= R_LOAD_RESET;
                            enc_x <= 0;
                        end
                    endcase
                end
            end
        end
    end
	 
	 
	 
	 
	 // -------------Y----------------
    always @(posedge clk) begin
        if (rst == 0) begin
            state_write_y <= W_IDLE;
            state_read_y <= R_LOAD_RESET;
            ptr_escritura_y <= 0;
            last_addr_y <= 0;
            ready_y <= 0;
            save_ant_y <= 0;
            selector_ant_y <= 0;
            we_y <= 0; enc_y <= 0; load_y <= 0; load_addr_y <= 0;
        end 
        else begin
            save_ant_y <= save;
            selector_ant_y <= selector;
            if (!selector) begin
                state_read_y <= R_LOAD_RESET;
                case (state_write_y)
                    W_IDLE: begin
                        we_y <= 0; enc_y <= 0; load_y <= 0;
                        if (~save && save_ant_y && en_y) begin
                            load_y <= 1;
                            load_addr_y <= ptr_escritura_y;
                            state_write_y <= W_ADDR;
                        end
                    end
                    W_ADDR: begin
                        load_y <= 0;
                        we_y <= 1;
                        enc_y <= 1;
                        reg_in_y <= {1'b0, in_y};
                        cronometro_y <= 0;
                        state_write_y <= W_POS;
                    end
                    W_POS: begin
                        we_y <= 0;
                        enc_y <= 0;
                        state_write_y <= W_TIME;
                    end
                    W_TIME: begin
                        if (tick_timer && ~save) cronometro_y <= cronometro_y + 1;
                        if (save) begin
                            we_y <= 1;
                            enc_y <= 1;
                            reg_in_y <= {1'b1, cronometro_y};
                            state_write_y <= W_WRITE_TIME;
                        end
                    end
                    W_WRITE_TIME: begin
                        we_y <= 0;
                        enc_y <= 0;
                        state_write_y <= W_DONE;
                    end
                    W_DONE: begin
                        ptr_escritura_y <= addr_y;
                        last_addr_y <= addr_y;
                        state_write_y <= W_IDLE;
                    end
                endcase
            end 
            else begin
                state_write_y <= W_IDLE;
                we_y <= 0;
                
                if ((selector && !selector_ant_y) || (addr_y >= last_addr_y && last_addr_y != 0)) begin
                    load_y <= 1; 
                    load_addr_y <= 0;
                    if (sync)
                        state_read_y <= R_SYNC;
                    else
                        state_read_y <= R_LOAD_RESET;
                end
                else begin
                    case (state_read_y)
                        R_LOAD_RESET: begin
                            load_y <= 0;
                            if (last_addr_y != 0) begin
                                ready_y <= 0;
                                enc_y <= 0;
                                state_read_y <= R_STEP1;
                            end
                            else
                                ready_y <= 1;
                            
                        end
                        R_STEP1: begin
                            enc_y <= 0;
                            state_read_y <= R_STEP2;
                        end
                        R_STEP2: begin
                            state_read_y <= R_CHECK;
                        end
                        R_CHECK: begin
                            if (data_oy[16] == 1'b0) begin 
                                enc_y <= 1;
                                state_read_y <= R_STEP1;
                            end 
                            else begin 
                                enc_y <= 0;
                                delay_counter_y <= 0;
                                state_read_y <= R_DELAY;
                            end
                        end
                        R_DELAY: begin
                            if (~selector)
                                state_read_y <= R_LOAD_RESET;
                            if (tick_timer) begin
                                if (delay_counter_y >= data_oy[15:0]) begin
                                    enc_y <= 1;
                                    state_read_y <= R_STEP1; 
                                end 
                                else begin
                                    delay_counter_y <= delay_counter_y + 1;
                                    enc_y <= 0;
                                end
                            end 
                            else enc_y <= 0;
                        end
                        R_SYNC: begin
                            ready_y <= 1;
                            if (ready_x && ready_z && ready_g) begin
                                state_read_y <= R_LOAD_RESET;
                            end
                            else begin
                                state_read_y <= R_SYNC;
                                enc_y <= 0;
                            end
                        end
                        default: begin
                            state_read_y <= R_LOAD_RESET;
                            enc_y <= 0;
                        end
                    endcase
                end
            end
        end
    end

    // -------------Z----------------
    always @(posedge clk) begin
        if (rst == 0) begin
            state_write_z <= W_IDLE;
            state_read_z <= R_LOAD_RESET;
            ptr_escritura_z <= 0;
            last_addr_z <= 0;
            ready_z <= 0;
            save_ant_z <= 0;
            selector_ant_z <= 0;
            we_z <= 0; enc_z <= 0; load_z <= 0; load_addr_z <= 0;
        end 
        else begin
            save_ant_z <= save;
            selector_ant_z <= selector;
            if (!selector) begin
                state_read_z <= R_LOAD_RESET;
                case (state_write_z)
                    W_IDLE: begin
                        we_z <= 0; enc_z <= 0; load_z <= 0;
                        if (~save && save_ant_z && en_z) begin
                            load_z <= 1;
                            load_addr_z <= ptr_escritura_z;
                            state_write_z <= W_ADDR;
                        end
                    end
                    W_ADDR: begin
                        load_z <= 0;
                        we_z <= 1;
                        enc_z <= 1;
                        reg_in_z <= {1'b0, in_z};
                        cronometro_z <= 0;
                        state_write_z <= W_POS;
                    end
                    W_POS: begin
                        we_z <= 0;
                        enc_z <= 0;
                        state_write_z <= W_TIME;
                    end
                    W_TIME: begin
                        if (tick_timer && ~save) cronometro_z <= cronometro_z + 1;
                        if (save) begin
                            we_z <= 1;
                            enc_z <= 1;
                            reg_in_z <= {1'b1, cronometro_z};
                            state_write_z <= W_WRITE_TIME;
                        end
                    end
                    W_WRITE_TIME: begin
                        we_z <= 0;
                        enc_z <= 0;
                        state_write_z <= W_DONE;
                    end
                    W_DONE: begin
                        ptr_escritura_z <= addr_z;
                        last_addr_z <= addr_z;
                        state_write_z <= W_IDLE;
                    end
                endcase
            end 
            else begin
                state_write_z <= W_IDLE;
                we_z <= 0;
                
                if ((selector && !selector_ant_z) || (addr_z >= last_addr_z && last_addr_z != 0)) begin
                    load_z <= 1; 
                    load_addr_z <= 0;
                    if (sync)
                        state_read_z <= R_SYNC;
                    else
                        state_read_z <= R_LOAD_RESET;
                end
                else begin
                    case (state_read_z)
                        R_LOAD_RESET: begin
                            load_z <= 0;
                            if (last_addr_z != 0) begin
                                ready_z <= 0;
                                enc_z <= 0;
                                state_read_z <= R_STEP1;
                            end
                            else
                                ready_z <= 1;
                            
                        end
                        R_STEP1: begin
                            enc_z <= 0;
                            state_read_z <= R_STEP2;
                        end
                        R_STEP2: begin
                            state_read_z <= R_CHECK;
                        end
                        R_CHECK: begin
                            if (data_oz[16] == 1'b0) begin 
                                enc_z <= 1;
                                state_read_z <= R_STEP1;
                            end 
                            else begin 
                                enc_z <= 0;
                                delay_counter_z <= 0;
                                state_read_z <= R_DELAY;
                            end
                        end
                        R_DELAY: begin
                            if (~selector)
                                state_read_z <= R_LOAD_RESET;
                            if (tick_timer) begin
                                if (delay_counter_z >= data_oz[15:0]) begin
                                    enc_z <= 1;
                                    state_read_z <= R_STEP1; 
                                end 
                                else begin
                                    delay_counter_z <= delay_counter_z + 1;
                                    enc_z <= 0;
                                end
                            end 
                            else enc_z <= 0;
                        end
                        R_SYNC: begin
                            ready_z <= 1;
                            if (ready_x && ready_y && ready_g) begin
                                state_read_z <= R_LOAD_RESET;
                            end
                            else begin
                                state_read_z <= R_SYNC;
                                enc_z <= 0;
                            end
                        end
                        default: begin
                            state_read_z <= R_LOAD_RESET;
                            enc_z <= 0;
                        end
                    endcase
                end
            end
        end
    end

    // -------------Garra (G)----------------
    always @(posedge clk) begin
        if (rst == 0) begin
            state_write_g <= W_IDLE;
            state_read_g <= R_LOAD_RESET;
            ptr_escritura_g <= 0;
            last_addr_g <= 0;
            ready_g <= 0;
            save_ant_g <= 0;
            selector_ant_g <= 0;
            we_g <= 0; enc_g <= 0; load_g <= 0; load_addr_g <= 0;
        end 
        else begin
            save_ant_g <= save;
            selector_ant_g <= selector;
            if (!selector) begin
                state_read_g <= R_LOAD_RESET;
                case (state_write_g)
                    W_IDLE: begin
                        we_g <= 0; enc_g <= 0; load_g <= 0;
                        if (~save && save_ant_g) begin
                            load_g <= 1;
                            load_addr_g <= ptr_escritura_g;
                            state_write_g <= W_ADDR;
                        end
                    end
                    W_ADDR: begin
                        load_g <= 0;
                        we_g <= 1;
                        enc_g <= 1;
                        reg_in_g <= {1'b0, in_g};
                        cronometro_g <= 0;
                        state_write_g <= W_POS;
                    end
                    W_POS: begin
                        we_g <= 0;
                        enc_g <= 0;
                        state_write_g <= W_TIME;
                    end
                    W_TIME: begin
                        if (tick_timer && ~save) cronometro_g <= cronometro_g + 1;
                        if (save) begin
                            we_g <= 1;
                            enc_g <= 1;
                            reg_in_g <= {1'b1, cronometro_g};
                            state_write_g <= W_WRITE_TIME;
                        end
                    end
                    W_WRITE_TIME: begin
                        we_g <= 0;
                        enc_g <= 0;
                        state_write_g <= W_DONE;
                    end
                    W_DONE: begin
                        ptr_escritura_g <= addr_g;
                        last_addr_g <= addr_g;
                        state_write_g <= W_IDLE;
                    end
                endcase
            end 
            else begin
                state_write_g <= W_IDLE;
                we_g <= 0;
                
                if ((selector && !selector_ant_g) || (addr_g >= last_addr_g && last_addr_g != 0)) begin
                    load_g <= 1; 
                    load_addr_g <= 0;
                    if (sync)
                        state_read_g <= R_SYNC;
                    else
                        state_read_g <= R_LOAD_RESET;
                end
                else begin
                    case (state_read_g)
                        R_LOAD_RESET: begin
                            load_g <= 0;
                            if (last_addr_g != 0)   begin
                                ready_g <= 0;
                                enc_g <= 0;
                                state_read_g <= R_STEP1;
                            end
                            else
                                ready_g <= 1;
                            
                        end
                        R_STEP1: begin
                            enc_g <= 0;
                            state_read_g <= R_STEP2;
                        end
                        R_STEP2: begin
                            state_read_g <= R_CHECK;
                        end
                        R_CHECK: begin
                            if (data_og[16] == 1'b0) begin 
                                enc_g <= 1;
                                state_read_g <= R_STEP1;
                            end 
                            else begin 
                                enc_g <= 0;
                                delay_counter_g <= 0;
                                state_read_g <= R_DELAY;
                            end
                        end
                        R_DELAY: begin
                            if (~selector)
                                state_read_g <= R_LOAD_RESET;
                            if (tick_timer) begin
                                if (delay_counter_g >= data_og[15:0]) begin
                                    enc_g <= 1;
                                    state_read_g <= R_STEP1; 
                                end 
                                else begin
                                    delay_counter_g <= delay_counter_g + 1;
                                    enc_g <= 0;
                                end
                            end 
                            else enc_g <= 0;
                        end
                        R_SYNC: begin
                            ready_g <= 1;
                            if (ready_x && ready_y && ready_z) begin
                                state_read_g <= R_LOAD_RESET;
                            end
                            else begin
                                state_read_g <= R_SYNC;
                                enc_g <= 0;
                            end
                        end
                        default: begin
                            state_read_g <= R_LOAD_RESET;
                            enc_g <= 0;
                        end
                    endcase
                end
            end
        end
    end
endmodule