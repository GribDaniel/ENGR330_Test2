#!/bin/bash
# =====================================================
# measure.sh - Synthesis and measurement script
# Engineer: Daniel Grib
# Project: ENGR330 Test 2
# =====================================================

set -e
mkdir -p results

# Detect Yosys
if ! command -v yosys &> /dev/null; then
  echo "❌ Yosys not found in PATH!"
  echo "Please add it using:"
  echo "  export PATH=\$PATH:\"/c/Program Files/yosys/oss-cad-suite/bin\""
  exit 1
fi

WIDTHS=(8 16 32 64)
TARGET=${1:-all}

run_synth() {
  local name=$1
  local src=$2

  for w in "${WIDTHS[@]}"; do
    echo
    echo "----------------------------------------------"
    echo "Synthesizing and measuring ${name^^} width = ${w} bits"
    echo "----------------------------------------------"

    local outfile="results/synth_report_${name}_W${w}.txt"
    
    # Run Yosys and store its own log directly
    yosys -l "$outfile" -p "read_verilog -sv ${src}; synth -top ${name}; stat -tech xilinx;"

    echo "✅ Results saved to $outfile"
  done
}

case "$TARGET" in
  rca)
    run_synth "rca" "adder_rtl/rca.sv"
    ;;
  cla)
    run_synth "cla" "adder_rtl/cla.sv"
    ;;
  pre|prefix)
    run_synth "prefix" "adder_rtl/prefix.sv"
    ;;
  all)
    run_synth "rca" "adder_rtl/rca.sv"
    run_synth "cla" "adder_rtl/cla.sv"
    run_synth "prefix" "adder_rtl/prefix.sv"
    ;;
  *)
    echo "Usage: bash synth/measure.sh [rca|cla|pre|all]"
    exit 1
    ;;
esac
