# Module 3: UART Transmitter

**Concepts practiced:** finite state machines, counters and clock division, serial protocols, asynchronous reset, parameters, timing-accurate verification with cocotb.

**Prerequisites:** [docs/02-digital-design-basics.md](../docs/02-digital-design-basics.md) (FSMs), [docs/03-hdl.md](../docs/03-hdl.md), [docs/04-verification-basics.md](../docs/04-verification-basics.md). Do the ALU and FIFO first.

A UART sends bytes one bit at a time over a single wire. There is no shared clock, so both ends agree on a **baud rate** ahead of time. This transmitter uses the common **8-N-1** frame: 8 data bits, no parity, 1 stop bit.

## Frame format

```
tx   idle   start    d0   d1   d2   d3   d4   d5   d6   d7    stop   idle
     ─────┐       ┌────┬────┬────┬────┬────┬────┬────┬────┐  ┌───────────
          └───────┘  (data bits, least-significant bit first)  ┘
           0 (low)                                             1 (high)
          |<-1 bit period each, = CLKS_PER_BIT clock cycles ->|
```

- The line idles **high**.
- **Start bit:** one bit period of `0`.
- **Data bits:** 8 bit periods, **LSB first** (`tx_data[0]` first).
- **Stop bit:** one bit period of `1`, after which the line idles high again.
- One bit period = `CLKS_PER_BIT = CLK_FREQ_HZ / BAUD_RATE` clock cycles. (Real hardware: 50 MHz / 115200 ≈ 434.)

## Interface (fixed - do not rename)

| Name | Dir | Width | Meaning |
| --- | --- | --- | --- |
| `CLK_FREQ_HZ`, `BAUD_RATE` (params) | - | - | set the bit period; `CLKS_PER_BIT` must be ≥ 2 |
| `clk` | in | 1 | clock |
| `rst_n` | in | 1 | **asynchronous**, active-low reset |
| `tx_start` | in | 1 | pulse high for one cycle to send `tx_data` |
| `tx_data` | in | 8 | byte to send (captured when `tx_start` is accepted) |
| `tx` | out | 1 | serial output |
| `tx_busy` | out | 1 | high while a frame is being sent |

## Behavioral spec

1. After reset: `tx = 1`, `tx_busy = 0`.
2. A one-cycle `tx_start` pulse while idle starts a frame. `tx_data` is captured at that edge, so it may change afterward.
3. `tx` goes low **in the same cycle `tx_busy` goes high** (the cycle after the `tx_start` edge is sampled) and stays low for exactly `CLKS_PER_BIT` cycles.
4. Each subsequent bit lasts exactly `CLKS_PER_BIT` cycles.
5. `tx_busy` stays high for the entire frame including the whole stop bit, and drops in the same cycle the frame ends.
6. `tx_start` while busy is **ignored**.
7. Asserting reset mid-frame returns immediately to idle.

## Note on the register-alignment pitfall

`tx` comes from a flip-flop (`tx_reg`). If you write `tx_reg <= data_reg[bit_index]` at the top of the DATA state, the value appears one cycle *after* the state changed, so `tx` lags `tx_busy` by a cycle and rule 5 breaks. The skeleton's comments show how to set `tx_reg` on the transition instead. Working out *why* this happens is a good exercise in reading a waveform: run the wrong version and look at `state`, `tx_reg` and `tx_busy` in GTKWave.

## What to do

1. **`uart_tx.sv`** - fill in `START`, `DATA`, `STOP`. `IDLE` is a worked example.
2. **`test_uart_tx.py`** - implement `send_and_check_byte()` (the docstring is a step-by-step recipe), then add the three extra tests listed at the bottom of the file.
3. `make` to run. `make waves` to inspect `dump.vcd`.
4. **Sanity-check your testbench:** temporarily send data MSB-first, or shorten a bit period by one cycle, and confirm the tests fail. Then undo it.

## Done when

- [ ] `make lint` is clean for your logic
- [ ] `test_idles_high`, `test_single_byte`, `test_edge_case_bytes`, `test_random_bytes`, `test_back_to_back`, `test_start_ignored_while_busy`, `test_reset_mid_frame` all pass
- [ ] your checker verifies both the *value* and the *duration* of every bit (not just a sample in the middle)
- [ ] the sanity check in step 4 made a test fail
- [ ] `dump.vcd` is committed
