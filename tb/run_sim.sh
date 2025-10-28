#!/bin/bash
# ===============================================
# run_sim.sh - Functional simulation script (CLA)
# Engineer : Daniel Grib
# Project  : ENGR330 Test 2 - Carry-Lookahead Adder
# ===============================================

set -e  # stop on any error

# Ensure folders exist
mkdir -p build
mkdir -p results

# File paths
CLA_SRC="adder_rtl/cla.sv"
TB_SRC="tb/tb_cla.sv"
OUT="build/tb_cla.vvp"
WAVE="results/waves_cla.vcd"

echo "=============================================="
echo "Compiling Carry-Lookahead Adder testbench..."
echo "=============================================="

# Compile structural CLA + testbench
iverilog -g2012 -o "$OUT" "$CLA_SRC" "$TB_SRC"

echo
echo "=============================================="
echo "Running CLA simulation..."
echo "=============================================="

# Execute the compiled simulation
vvp "$OUT"

echo
echo "=============================================="
echo "Simulation complete!"
echo "Waveform saved to: $WAVE"
echo "To view results, run:"
echo "  gtkwave $WAVE"
echo "=============================================="
