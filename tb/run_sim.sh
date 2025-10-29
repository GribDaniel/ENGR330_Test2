#!/bin/bash
# ===============================================
# run_sim.sh - Functional simulation script (Prefix)
# Engineer : Daniel Grib
# Project  : ENGR330 Test 2 - Prefix Adder
# ===============================================

set -e  # stop on any error

# Ensure folders exist
mkdir -p build
mkdir -p results

# File paths
PREFIX_SRC="adder_rtl/prefix.sv"
TB_SRC="tb/tb_pre.sv"
OUT="build/tb_pre.vvp"
WAVE="results/waves_pre.vcd"

echo "=============================================="
echo "Compiling Prefix Adder testbench..."
echo "=============================================="

# Compile prefix adder + testbench
iverilog -g2012 -o "$OUT" "$PREFIX_SRC" "$TB_SRC"

echo
echo "=============================================="
echo "Running Prefix Adder simulation..."
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
