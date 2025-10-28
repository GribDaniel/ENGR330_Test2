#!/bin/bash
# run_sim.sh - compile & run simulations for multiple bit-widths
set -e  # stop if any command fails

BUILD_DIR="build"
RESULTS_DIR="results"
RTL_DIR="adder_rtl"
TB_DIR="tb"

mkdir -p "$BUILD_DIR" "$RESULTS_DIR"

for WIDTH in 8 16 32 64; do
  echo "=============================="
  echo "Running simulation for WIDTH=${WIDTH}"
  echo "=============================="

  iverilog -g2012 -o "${BUILD_DIR}/tb_W${WIDTH}.vvp" -DWIDTH=${WIDTH} \
    ${RTL_DIR}/*.sv ${TB_DIR}/tb_adders.sv

  vvp "${BUILD_DIR}/tb_W${WIDTH}.vvp" | tee "${RESULTS_DIR}/sim_W${WIDTH}.log"
done

echo "✅ All simulations complete. Waveforms saved to ${RESULTS_DIR}/waves_W*.vcd"
