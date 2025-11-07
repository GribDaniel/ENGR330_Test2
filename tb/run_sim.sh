#!/bin/bash
# =====================================================
# run_sim.sh - Functional Simulation Script (Universal Testbench)
# Engineer: Daniel Grib
# Project: ENGR330 Test 2
# =====================================================

set -e  # Stop if any command fails

# Create folders if missing
mkdir -p build
mkdir -p results

# Source RTL paths
RCA_SRC="adder_rtl/rca.sv"
CLA_SRC="adder_rtl/cla.sv"
PRE_SRC="adder_rtl/prefix.sv"

# Shared testbench and vector file
TB_FILE="tb/tb_adder.sv"
VEC_FILE="tb/test_vectors.txt"

# Argument: which design to simulate
TARGET=${1:-all}  # default = all

# -----------------------------------------------
# Helper function to compile and simulate
# -----------------------------------------------
run_sim() {
    local name=$1
    local src=$2
    local out="build/tb_${name}.vvp"
    local wave="results/waves_${name}.vcd"

    echo
    echo "=============================================="
    echo "Compiling ${name^^} testbench..."
    echo "=============================================="

    # Select which DUT to build
    case "$name" in
        rca)
            macro="-D TARGET_RCA"
            ;;
        cla)
            macro="-D TARGET_CLA"
            ;;
        pre|prefix)
            macro="-D TARGET_PREFIX"
            ;;
        *)
            echo "❌ Unknown adder type: $name"
            exit 1
            ;;
    esac

    # Compile with Icarus Verilog (SystemVerilog 2012)
    iverilog -g2012 $macro -o "$out" "$src" "$TB_FILE"

    echo
    echo "=============================================="
    echo "Running ${name^^} simulation..."
    echo "=============================================="
    vvp "$out" +VEC_FILE="$VEC_FILE" +WAVE_FILE="$wave"
    echo "=============================================="
    echo "✅ Simulation complete for ${name^^}"
    echo "✅ Waveform: $wave"
    echo "Open with: gtkwave $wave"
    echo "=============================================="
}

# -----------------------------------------------
# Run simulations based on argument
# -----------------------------------------------
case "$TARGET" in
    rca)
        run_sim "rca" "$RCA_SRC"
        ;;
    cla)
        run_sim "cla" "$CLA_SRC"
        ;;
    pre|prefix)
        run_sim "prefix" "$PRE_SRC"
        ;;
    all)
        run_sim "rca" "$RCA_SRC"
        run_sim "cla" "$CLA_SRC"
        run_sim "prefix" "$PRE_SRC"
        ;;
    *)
        echo "Usage: bash tb/run_sim.sh [rca|cla|prefix|all]"
        exit 1
        ;;
esac
