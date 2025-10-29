#!/bin/bash
# ===============================================
# measure.sh - Measurement script (Prefix Adder)
# Engineer : Daniel Grib
# Project  : ENGR330 Test 2 - Prefix Adder
# ===============================================

set -e
mkdir -p build
mkdir -p results

PREFIX_SRC="adder_rtl/prefix.sv"
TB_SRC="tb/tb_pre.sv"

# Bit-widths to measure (even though tb_pre tests all)
WIDTHS=(8 16 32 64)

echo "=============================================="
echo "Running Prefix Adder measurements"
echo "=============================================="

for W in "${WIDTHS[@]}"; do
    OUT="build/tb_pre_W${W}.vvp"
    LOG="results/synth_report_pre_W${W}.txt"

    echo
    echo "----------------------------------------------"
    echo "Simulating Prefix Adder width = $W bits"
    echo "----------------------------------------------"

    # Compile (multi-width testbench already includes all widths)
    iverilog -g2012 -o "$OUT" "$PREFIX_SRC" "$TB_SRC"

    # Run simulation and log execution time
    { time vvp "$OUT" > "$LOG"; } 2>> "$LOG"

    echo "Results saved to $LOG"
done

echo
echo "=============================================="
echo "All Prefix Adder measurements complete."
echo "Logs available in results/."
echo "=============================================="
