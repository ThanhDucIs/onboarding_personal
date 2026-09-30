# Synchronous FIFO: cocotb testbench on Verilator.
#   make        run all cocotb tests (writes dump.vcd)
#   make lint   static checks on the RTL only
#   make waves  open dump.vcd in GTKWave
#   make clean
#
# Requires cocotb >= 2.0 and Verilator >= 5.036 (see docs/01-setup.md).

SIM ?= verilator
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES = $(CURDIR)/sync_fifo.sv
COCOTB_TOPLEVEL = sync_fifo
COCOTB_TEST_MODULES = test_sync_fifo

# Dump waveforms (Verilator writes dump.vcd in this folder).
COMPILE_ARGS += --trace --trace-structs
SIM_ARGS += --trace

include $(shell cocotb-config --makefiles)/Makefile.sim

.PHONY: lint waves
lint:
	verilator --lint-only -Wall -Wno-DECLFILENAME sync_fifo.sv

waves:
	gtkwave dump.vcd &
