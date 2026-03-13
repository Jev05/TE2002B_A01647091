transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/admin_mem.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer/hdl {/home/sesgaro/DisenoC/brazo/Accelerometer/hdl/spi_serdes.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer/hdl {/home/sesgaro/DisenoC/brazo/Accelerometer/hdl/spi_control.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/accel.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/PLL.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/clock_divider.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/servo_control.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/counter.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/counter_mem.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/counter_rampa.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/convertidor.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/mem_brazo.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer/db {/home/sesgaro/DisenoC/brazo/Accelerometer/db/PLL_altpll.v}

vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/admin_mem_tb.v}
vlog  -work work +incdir+/home/sesgaro/DisenoC/brazo/Accelerometer {/home/sesgaro/DisenoC/brazo/Accelerometer/admin_mem.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  admin_mem_tb

add wave *
view structure
view signals
run -all
