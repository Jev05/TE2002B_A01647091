transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+C:/Users/pelay/Downloads/TC2002B/numeros_primos {C:/Users/pelay/Downloads/TC2002B/numeros_primos/numeros_primos.v}

vlog  -work work +incdir+C:/Users/pelay/AppData/Local/quartus/../../../Downloads/TC2002B/numeros_primos {C:/Users/pelay/AppData/Local/quartus/../../../Downloads/TC2002B/numeros_primos/numeros_primos_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  numeros_primos_tb

add wave *
view structure
view signals
run -all
