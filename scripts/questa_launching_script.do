#create lib
vlib work

pwd

#compile
vlog ../tb/crv/test.sv
vlog ../tb/crv/tb_top.sv
vlog ../rtl/cross_bar.sv

#elaborate without optimization
vsim work.tb_top 

#waves
source "waves.tcl"

#simulate
run -all