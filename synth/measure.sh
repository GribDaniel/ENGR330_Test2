#!/bin/bash
# =====================================================
# measure.sh - Functional + Timing Measurement Script
# Engineer: Daniel Grib
# Project: ENGR330 Test 2
# =====================================================

set -e
mkdir -p build
mkdir -p results

# --- Source and testbench paths ---
RCA_SRC="adder_rtl/rca.sv"
CLA_SRC="adder_rtl/cla.sv"
PRE_SRC="adder_rtl/prefix.sv"
TB_FILE="tb/tb_adder.sv"
VEC_FILE="tb/test_vectors.txt"

WIDTHS=(8 16 32 64)
TARGET=${1:-all}

# Estimated per-gate delays (ns)
DELAY_XOR=0.12
DELAY_AND=0.10
DELAY_OR=0.08

# -----------------------------------------------
# Timing estimation (no Yosys)
# -----------------------------------------------
estimate_timing() {
    local name=$1
    local width=$2
    local outfile="results/timing_${name}_W${width}.txt"
    local levels=0 delay_ns=0

    case "$name" in
        rca)    levels=$((2 * width)) ;;
        cla)    levels=$(( (width / 4) + 4 )) ;;
        prefix)
            local log2=0 tmp=$width
            while [ $tmp -gt 1 ]; do tmp=$((tmp / 2)); log2=$((log2 + 1)); done
            levels=$((log2 + 3))
            ;;
        *) echo "Unknown architecture: $name"; return ;;
    esac

    delay_ns=$(awk -v l=$levels -v dx=$DELAY_XOR -v da=$DELAY_AND -v dor=$DELAY_OR \
        'BEGIN { printf "%.3f", l * (dx + (da+dor)/2) }')

    {
        echo "----------------------------------------------"
        echo "Timing Estimate for ${name^^} (${width}-bit)"
        echo "----------------------------------------------"
        echo "Logic levels: $levels"
        echo "Estimated propagation delay: ${delay_ns} ns"
    } > "$outfile"

    echo "✅ ${name^^} ${width}-bit → ${delay_ns} ns"
}

# -----------------------------------------------
# Functional + timing measurement runner
# -----------------------------------------------
run_measure() {
    local name=$1
    local src=$2
    local macro
    local out="build/meas_${name}.vvp"
    local wave="results/waves_${name}.vcd"
    local log="results/sim_${name}.log"

    case "$name" in
        rca)    macro="-D TARGET_RCA" ;;
        cla)    macro="-D TARGET_CLA" ;;
        pre|prefix) macro="-D TARGET_PREFIX" ;;
        *) echo "❌ Unknown adder type: $name"; exit 1 ;;
    esac

    echo
    echo "=============================================="
    echo "Compiling and simulating ${name^^}..."
    echo "=============================================="

    # Compile the DUT + universal testbench
    iverilog -g2012 $macro -o "$out" "$src" "$TB_FILE"

    # Run with test vectors (plusargs) and capture log
    vvp "$out" +VEC_FILE="$VEC_FILE" +WAVE_FILE="$wave" | tee "$log"

    echo "✅ Functional test complete → log: $log"
    echo "✅ Waveform: $wave"

    # Do timing estimation
    for w in "${WIDTHS[@]}"; do
        estimate_timing "$name" "$w"
    done

    echo "----------------------------------------------"
    echo "✅ ${name^^} done."
    echo "----------------------------------------------"
}

# -----------------------------------------------
# Architecture selector
# -----------------------------------------------
case "$TARGET" in
    rca)
        run_measure "rca" "$RCA_SRC"
        ;;
    cla)
        run_measure "cla" "$CLA_SRC"
        ;;
    pre|prefix)
        run_measure "prefix" "$PRE_SRC"
        ;;
    all)
        run_measure "rca" "$RCA_SRC"
        run_measure "cla" "$CLA_SRC"
        run_measure "prefix" "$PRE_SRC"
        ;;
    *)
        echo "Usage: bash synth/measure.sh [rca|cla|pre|all]"
        exit 1
        ;;
esac
