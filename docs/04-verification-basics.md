# Introduction to Design Verification & Simulation

## Why verification matters

A design that "looks right" and a design that's *correct* are different things. On a real ASIC, a bug caught in simulation costs nothing. A bug caught after tapeout costs the team the whole chip and there's no patching silicon. Verification is how you close that gap before it's expensive. You drive known stimulus into a design and check that its outputs match what they should be, automatically, without a human eyeballing waveforms every time.

This is also why every ASICWRU onboarding project and flagship project ships with a testbench alongside the RTL. The RTL isn't "done" when it compiles; it is done when its testbench passes all cases.

## What a testbench actually is

A testbench is code that sits around your design (the **DUT**, device under test) and:

1. **Drives inputs** — applies known values to the DUT's input ports
2. **Waits** — lets the DUT react (usually: waits for a clock edge)
3. **Checks outputs** — compares what the DUT produced against what you expected
4. **Reports pass/fail** — automatically, with no human reading a waveform

```
        ┌─────────────┐
 stim → │             │ → outputs
        │     DUT     │
 clk  → │             │
        └─────────────┘
              ↑
        testbench drives inputs,
        checks outputs against
        an expected/reference model
```

A **self-checking testbench** is one that asserts pass/fail on its own. You run it and get a clear "9/9 tests passed" or "FAILED: expected 0x0A, got 0x0B at cycle 42," not a waveform you have to inspect by hand. This is the standard for every project. Waveform viewing (GTKWave) is for *debugging* a failure, not for verifying correctness in the first place.

## Directed vs. random testing

- **Directed tests** — you pick specific inputs to check specific behavior: known operations, boundary values (all-zeros, all-ones, max/min), and cases you know are tricky (e.g. a FIFO exactly full, exactly empty).
- **Randomized tests** — you throw many random inputs at the DUT and check each one against a reference model. This catches bugs you didn't think to test for directly. A few hundred random cycles will usually find a bug that ten hand-picked cases miss.

Good testbenches use both: directed tests for known edge cases, randomized tests for coverage you didn't think of. Look at how the ALU project structures this — `test_edge_cases`, `test_random_operations`, and `test_invalid_opcodes` are three different testing *strategies*, not just three test functions.

## cocotb quickstart

ASICWRU testbenches are written in **cocotb** - a Python-based verification framework that drives a Verilog/SystemVerilog DUT running under a simulator (we use Verilator). You write ordinary Python; cocotb handles the simulator handshake.

The core pieces:

```python
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

@cocotb.test()
async def test_example(dut):
    # start a clock on dut.clk: 10ns period
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # reset
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 3)
    dut.rst_n.value = 1

    # drive an input, wait a cycle, check an output
    dut.a.value = 5
    dut.b.value = 3
    await RisingEdge(dut.clk)

    # Allow the edge to register
    await Timer(1, unit="ns")
    assert dut.sum.value == 8, f"expected 8, got {dut.sum.value}"
```

Things to know:

- `@cocotb.test()` marks an `async` function as a test case; a testbench file can (and should) have several
- `dut.<signal>.value = x` drives a signal; `dut.<signal>.value` reads one
- `await RisingEdge(dut.clk)` / `await ClockCycles(dut.clk, n)` are how you advance simulated time — nothing happens in the DUT until you `await` a clock edge
- Everything is Python, so build reference models in plain Python (e.g. `expected = a + b`) and assert the DUT matches — this reference model *is* your "known-correct" answer
- Assertions that fail print immediately with the values involved, which is why cocotb tests are self-checking by default — no separate pass/fail scoring step needed

## Running the tests

Every project repo has a `Makefile` that wires Verilator + cocotb together:

```bash
make        # compiles the RTL and runs every cocotb test
make clean  # wipes build artifacts for a clean re-run
```

Output is a per-test pass/fail summary. If something fails, cocotb prints the assertion that tripped, which is then the starting point for debugging, not a waveform dump. Reach for GTKWave (`*.vcd` file, generated automatically on a failing run) only once you need to see *why* a specific cycle produced the wrong value.

## Done when (the standard to hold your own testbenches to)

A testbench for a new project should, at minimum:

- [ ] Cover every documented operation/mode at least once (directed)
- [ ] Cover boundary conditions specific to the design (overflow, full/empty, min/max, reset behavior)
- [ ] Include a randomized test with a reference model, run for enough iterations to be meaningful (50–100+)
- [ ] Fail loudly and specifically when something's wrong — no silent passes, no "looks fine" from eyeballing a waveform