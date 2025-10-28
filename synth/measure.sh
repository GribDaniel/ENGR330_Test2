#!/usr/bin/env bash
set -euo pipefail

# If you have a liberty, set LIB=/path/to/liberty.lib for better timing.
# Otherwise we use tech-independent stats & logic levels.
: "${LIB:=}"

WIDTHS=("8" "16" "32" "64")
MODS=("rca" "cla" "prefix_adder")

mkdir -p results synth_build

for M in "${MODS[@]}"; do
  for W in "${WIDTHS[@]}"; do
    OUT="results/${M}_W${W}.rpt"
    echo "=== Synthesize $M WIDTH=$W ==="
    yosys -q -l synth_build/${M}_W${W}.yosys.log -p "
      read_verilog adder_rtl/rca.v adder_rtl/cla.v adder_rtl/prefix.v;
      chparam -set WIDTH $W $M;
      synth -top $M;
      opt_clean;
      stat;
      write_json synth_build/${M}_W${W}.json;
      " > /dev/null

    if [[ -n "$LIB" ]]; then
      yosys -q -p "
        read_verilog adder_rtl/rca.v adder_rtl/cla.v adder_rtl/prefix.v;
        chparam -set WIDTH $W $M;
        synth -top $M;
        dfflibmap -liberty $LIB;
        abc -liberty $LIB;
        stat -liberty $LIB;
      " > "$OUT"
    else
      yosys -q -p "
        read_verilog adder_rtl/rca.v adder_rtl/cla.v adder_rtl/prefix.v;
        chparam -set WIDTH $W $M;
        synth -top $M;
        abc -D 1000;
        stat -tech cmos;
      " > "$OUT"
    fi
    echo "Report: $OUT"
  done
done

echo
echo "Done. See results/*.rpt for area/levels and (if LIB set) timing/Fmax."
