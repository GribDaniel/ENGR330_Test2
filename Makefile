SHELL := /usr/bin/env bash

WIDTH ?= 32

.PHONY: all sim synth clean

all: sim synth

sim:
	@bash tb/run_sim.sh

synth:
	@bash synth/measure.sh

clean:
	rm -rf build synth_build results/*.log results/*.vcd results/*.rpt
