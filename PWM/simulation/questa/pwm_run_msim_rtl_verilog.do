transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+C:/Users/pelay/Downloads/TC2002B/PWM {C:/Users/pelay/Downloads/TC2002B/PWM/clk_div.v}
vlog  -work work +incdir+C:/Users/pelay/Downloads/TC2002B/PWM {C:/Users/pelay/Downloads/TC2002B/PWM/contador.v}
vlog  -work work +incdir+C:/Users/pelay/Downloads/TC2002B/PWM {C:/Users/pelay/Downloads/TC2002B/PWM/contador_w.v}

