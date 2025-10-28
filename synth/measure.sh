#!/bin/bash
# ===============================================
# measure.sh - Post-synthesis timing/resource script
# Engineer: Daniel Grib
# Project: ENGR330 Test 2
# ===============================================

set -e  # stop on first error
mkdir -p results

RCA_SRC="adder_rtl/rca.sv"
TB_SRC="tb/tb_rca.sv"

# Bit-widths to evaluate
WIDTHS=(8 16 32 64)

echo "=============================================="
echo "Running synthesis / timing measurements"
echo "=============================================="

for W in "${WIDTHS[@]}"; do
    OUT="results/rca_W${W}.vvp"
    LOG="results/synth_report_W${W}.txt"

    echo
    echo "----------------------------------------------"
    echo "Synthesizing and measuring RCA width = $W bits"
    echo "----------------------------------------------"

    # Compile with parameter override
    iverilog -g2012 -o "$OUT" -P rca.N=$W "$RCA_SRC" "$TB_SRC"

    # Run and capture timing info
    { time vvp "$OUT" > "$LOG"; } 2>> "$LOG"

    echo "Results saved to $LOG"
done

echo
echo "=============================================="
echo "All measurements complete."
echo "Logs are in results/."
echo "=============================================="
