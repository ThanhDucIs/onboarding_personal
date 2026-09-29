/* cocotb testbench for uart_tx.sv

CLKS_PER_BIT here MUST match CLK_FREQ_HZ / BAUD_RATE that the DUT is built
with. The DUT's parameters get overridden to something small for fast
simulation (e.g. CLK_FREQ_HZ=1000, BAUD_RATE=100 -> 10 clks/bit) — update
the constant below to match whatever the Makefile builds with.

What to do:
    reset_dut() is done for you as a worked example. Implement
    send_and_check_byte() below — everything else calls it.

Done when:
    test_idles_high, test_single_byte, test_edge_case_bytes, and
    test_random_bytes all pass with no failures.
*/

import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

CLKS_PER_BIT = 10


async def reset_dut(dut):
    dut.rst_n.value = 0
    dut.tx_start.value = 0
    dut.tx_data.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)


async def send_and_check_byte(dut, byte_val):
    """TODO: implement this.

    1. Pulse tx_start high for 1 cycle with tx_data set to byte_val.
    2. Sample tx during the start bit and assert it's low.
    3. For each of the 8 data bits (LSB first), assert tx matches
       (byte_val >> i) & 1, advancing CLKS_PER_BIT cycles between checks.
    4. Sample tx during the stop bit and assert it's high.
    5. Wait for tx_busy to drop back to 0 and assert it did.
    """
    raise NotImplementedError


@cocotb.test()
async def test_idles_high(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset_dut(dut)
    assert dut.tx.value == 1, "tx should idle high out of reset"
    assert dut.tx_busy.value == 0, "tx_busy should be low when idle"


@cocotb.test()
async def test_single_byte(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset_dut(dut)
    await send_and_check_byte(dut, 0xA5)


@cocotb.test()
async def test_edge_case_bytes(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset_dut(dut)
    for val in [0x00, 0xFF, 0x01, 0x80]:
        await send_and_check_byte(dut, val)


@cocotb.test()
async def test_random_bytes(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset_dut(dut)
    for _ in range(20):
        await send_and_check_byte(dut, random.randint(0, 255))