transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog  -work work +incdir+. {Accelerometer.vo}

vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/admin_mem_tb.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/admin_mem.v}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  admin_mem_tb

add wave *
view structure
view signals
run -all
