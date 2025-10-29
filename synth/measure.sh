#!/bin/bash
# ===============================================
# measure.sh - Post-simulation measurement script (CLA)
# Engineer : Daniel Grib
# Project  : ENGR330 Test 2 - Carry-Lookahead Adder
# ===============================================

set -e
mkdir -p build
mkdir -p results

CLA_SRC="adder_rtl/cla.sv"
TB_SRC="tb/tb_cla.sv"

WIDTHS=(8 16 32 64)

echo "=============================================="
echo "Running Carry-Lookahead Adder measurements"
echo "=============================================="

for W in "${WIDTHS[@]}"; do
    OUT="build/tb_cla_W${W}.vvp"
    LOG="results/synth_report_cla_W${W}.txt"

    echo
    echo "----------------------------------------------"
    echo "Simulating CLA width = $W bits"
    echo "----------------------------------------------"

    # Compile without parameter override (multi-width testbench already handles all)
    iverilog -g2012 -o "$OUT" "$CLA_SRC" "$TB_SRC"

    # Run simulation and capture timing
    { time vvp "$OUT" > "$LOG"; } 2>> "$LOG"

    echo "Results saved to $LOG"
done

echo
echo "=============================================="
echo "All CLA measurements complete."
echo "Logs available in results/."
echo "=============================================="
