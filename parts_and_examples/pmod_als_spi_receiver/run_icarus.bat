rd /s /q sim
md sim
cd sim

\iverilog\bin\iverilog ../*.v
\iverilog\bin\vvp a.out
\iverilog\gtkwave\bin\gtkwave.exe dump.vcd
