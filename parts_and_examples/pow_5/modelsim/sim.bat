rd /s /q sim
md sim
cd sim

vlib work
vlog -vlog01compat +incdir+.. ../*.v >> z
type z
vsim -c -do "run -all" testbench
