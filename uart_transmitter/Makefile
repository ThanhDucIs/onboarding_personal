# UART transmitter: cocotb testbench on Verilator.
#   make        run all cocotb tests (writes dump.vcd)
#   make lint   static checks on the RTL only
#   make waves  open dump.vcd in GTKWave
#   make clean
#
# Requires cocotb >= 2.0 and Verilator >= 5.036 (see docs/01-setup.md).

SIM ?= verilator
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES = $(CURDIR)/uart_tx.sv
COCOTB_TOPLEVEL = uart_tx
COCOTB_TEST_MODULES = test_uart_tx

# Shrink the clock/baud ratio so simulations are fast: 1000 / 100 = 10 clocks per bit.
# CLKS_PER_BIT in test_uart_tx.py must equal this ratio.
COMPILE_ARGS += -GCLK_FREQ_HZ=1000 -GBAUD_RATE=100

# Dump waveforms (Verilator writes dump.vcd in this folder).
COMPILE_ARGS += --trace --trace-structs
SIM_ARGS += --trace

include $(shell cocotb-config --makefiles)/Makefile.sim

.PHONY: lint waves
lint:
	verilator --lint-only -Wall -Wno-DECLFILENAME uart_tx.sv

waves:
	gtkwave dump.vcd &
