#!/bin/bash
# ===============================================
# run_sim.sh - Functional Simulation Script
# Engineer: Daniel Grib
# Project: ENGR330 Test 2
# ===============================================

set -e  # Stop if any command fails

# Create folders if missing
mkdir -p build
mkdir -p results

# Define file paths for all adders
RCA_SRC="adder_rtl/rca.sv"
CLA_SRC="adder_rtl/cla.sv"
PRE_SRC="adder_rtl/prefix.sv"

TB_RCA="tb/tb_rca.sv"
TB_CLA="tb/tb_cla.sv"
TB_PRE="tb/tb_pre.sv"

# Argument: which design to simulate
TARGET=${1:-all}  # default = all

# -----------------------------------------------
# Helper function to compile and simulate
# -----------------------------------------------
run_sim() {
    local name=$1
    local src=$2
    local tb=$3
    local out="build/tb_${name}.vvp"
    local wave="results/waves_${name}.vcd"

    echo
    echo "=============================================="
    echo "Compiling ${name^^} testbench..."
    echo "=============================================="
    iverilog -g2012 -o "$out" "$src" "$tb"

    echo
    echo "=============================================="
    echo "Running ${name^^} simulation..."
    echo "=============================================="
    vvp "$out"

    echo
    echo "Simulation complete!"
    echo "Waveform: $wave"
    echo "Open with: gtkwave $wave"
    echo "=============================================="
}

# -----------------------------------------------
# Run simulations based on argument
# -----------------------------------------------
case "$TARGET" in
    rca)
        run_sim "rca" "$RCA_SRC" "$TB_RCA"
        ;;
    cla)
        run_sim "cla" "$CLA_SRC" "$TB_CLA"
        ;;
    pre|prefix)
        run_sim "pre" "$PRE_SRC" "$TB_PRE"
        ;;
    all)
        run_sim "rca" "$RCA_SRC" "$TB_RCA"
        run_sim "cla" "$CLA_SRC" "$TB_CLA"
        run_sim "pre" "$PRE_SRC" "$TB_PRE"
        ;;
    *)
        echo "Usage: bash tb/run_sim.sh [rca|cla|pre|all]"
        exit 1
        ;;
esac
