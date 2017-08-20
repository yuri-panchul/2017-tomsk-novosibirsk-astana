#!/bin/sh

rm -rf sim
mkdir sim
cd sim

cp ../*.hex .

vsim -do ../modelsim_script.tcl

cd ..
