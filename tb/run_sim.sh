#!/bin/bash
# ===============================================
# run_sim.sh - Functional simulation script
# Engineer: Daniel Grib
# Project: ENGR330 Test 2
# ===============================================

set -e

# Create folders if missing
mkdir -p build
mkdir -p results

# File paths
RCA_SRC="adder_rtl/rca.sv"
TB_SRC="tb/tb_rca.sv"
OUT="build/tb_rca.vvp"
WAVE="results/waves_rca.vcd"

echo "=============================================="
echo "Compiling Ripple-Carry Adder testbench..."
echo "=============================================="

# Compile into build folder using SystemVerilog 2012
iverilog -g2012 -o "$OUT" "$RCA_SRC" "$TB_SRC"

echo
echo "=============================================="
echo "Running simulation..."
echo "=============================================="

# Run from build directory to keep outputs tidy
vvp "$OUT"

echo
echo "Simulation complete!"
echo "Waveform: $WAVE"
echo "Open with: gtkwave $WAVE"
echo "=============================================="
