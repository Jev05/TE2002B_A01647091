transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+C:/Users/pelay/Downloads/TC2002B/Debouncer {C:/Users/pelay/Downloads/TC2002B/Debouncer/segments.v}
vlog  -work work +incdir+C:/Users/pelay/Downloads/TC2002B/Debouncer {C:/Users/pelay/Downloads/TC2002B/Debouncer/BCD_4displays.v}
vlog  -work work +incdir+C:/Users/pelay/Downloads/TC2002B/Debouncer {C:/Users/pelay/Downloads/TC2002B/Debouncer/clk_div.v}
vlog  -work work +incdir+C:/Users/pelay/Downloads/TC2002B/Debouncer {C:/Users/pelay/Downloads/TC2002B/Debouncer/top.v}
vlog  -work work +incdir+C:/Users/pelay/Downloads/TC2002B/Debouncer {C:/Users/pelay/Downloads/TC2002B/Debouncer/contador.v}

vlog  -work work +incdir+C:/Users/pelay/Downloads/TC2002B/Debouncer {C:/Users/pelay/Downloads/TC2002B/Debouncer/top_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  top_tb

add wave *
view structure
view signals
run -all
