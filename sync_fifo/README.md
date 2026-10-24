# Module 2: Synchronous FIFO

**Concepts practiced:** sequential logic, memories (arrays), read/write pointers, full/empty detection, reset, reference-model verification with cocotb.

**Prerequisites:** [docs/02-digital-design-basics.md](../docs/02-digital-design-basics.md), [docs/03-hdl.md](../docs/03-hdl.md), [docs/04-verification-basics.md](../docs/04-verification-basics.md).

A FIFO (first-in, first-out) buffer returns data in the order it was written. Here, one clock drives both the write and read sides.

## Interface (fixed - do not rename)

| Name | Dir | Width | Meaning |
| --- | --- | --- | --- |
| `DEPTH` (param) | - | - | words stored; **must be a power of two** (default 8) |
| `DWIDTH` (param) | - | - | bits per word (default 16) |
| `clk` | in | 1 | clock; everything happens on the rising edge |
| `rst_n` | in | 1 | **synchronous**, active-low reset |
| `wr_en` | in | 1 | request to write `din` |
| `rd_en` | in | 1 | request to read a word |
| `din` | in | `DWIDTH` | data to write |
| `dout` | out | `DWIDTH` | data read |
| `empty` | out | 1 | no data stored |
| `full` | out | 1 | `DEPTH` words stored |

## Behavioral spec

Judge every rule below using the value of `full`/`empty` **before** the rising edge.

1. **Reset:** `empty=1`, `full=0`, `dout=0`. The stored contents no longer matter.
2. **Write:** if `wr_en && !full` (`wr_en & ~full`) at a rising edge, `din` is stored. If `full`, the write is **ignored** (no data lost, no pointer change).
3. **Read:** if `rd_en && !empty` (`rd_en & ~empty`) at a rising edge, the oldest word is loaded into `dout` at that edge. If `empty`, the read is **ignored** and `dout` keeps its old value.
4. **`dout` is registered:** it changes only on an accepted read, and holds its value otherwise. `dout` is a data output, so it only changes when theres a new read value accepted. So the word you read shows up on `dout` in the cycle *after* the one where you raised, call, `rd_en`.
5. **Simultaneous read and write** (neither full nor empty): both happen. If the FIFO is **empty**, only the write happens; if **full**, only the read happens.
6. **Capacity:** the FIFO holds exactly `DEPTH` words (`full` becomes 1 after `DEPTH` accepted writes with no reads).

## How the pointers work

`$clog2(DEPTH)` is a SystemVerilog function that gives the number of bits needed to address DEPTH memory slots inside `FIFO` memory. If `DEPTH = 8`, the the function returns 3 bits for 0 to 7, so it works by finding `n of 2^n = a`. + 1 Adds an extra wraparound bit to read, `wptr`, and write, `rptr`, pointers, to total of 4 bits.

`wptr` and `rptr` are `$clog2(DEPTH) + 1` bits wide. The low bits select a slot in `mem`; the top bit flips every time the pointer wraps past the last slot. Then:

- `empty` when the pointers are identical
- `full` when the low bits match but the top bits differ (the writer has lapped the reader)

You'll see other designs on the web that leave one slot unused instead (`full` when `wptr + 1 == rptr`). That works too but stores only `DEPTH - 1` words and does not meet this spec.

Assume the `FIFO` has `DEPTH = 4`, so the pointers have 3 bits: 2 slot bits plus 1 wrap bit. The memory slots are 0–3.

Initially, both pointers are `000`:

`wptr = 000   rptr = 000   //FIFO is empty`

Write `A`, then `B`. Each write stores data at the slot `wptr` points to, then advances it:

`After writing A: mem[0] = A, wptr = 001, rptr = 000`

`After writing B: mem[1] = B, wptr = 010, rptr = 000`

Now read once. `rptr` points to slot 0, so the `FIFO` returns `A`, then advances:

`dout = A, wptr = 010, rptr = 001`

The pointers move independently: writes advance `wptr`; reads advance `rptr`. When either reaches the end, its slot bits wrap to `0` and its extra bit flips.

For `DEPTH = 8`, the pointers are 4 bits wide: 3 bits select one of the 8 slots, and 1 extra bit tracks wraparound.

`Pointer | Slot | Wrapbit`

`0000   |||| 0 || 0  `

`0001   |||| 1 || 0 `

`0010   |||| 2 || 0`

`0011   |||| 3 || 0`

`0100   |||| 4 || 0`

`0101   |||| 5 || 0`

`0110   |||| 6 || 0`

`0111   |||| 7 || 0`

`1000   |||| 0 || 1  <- wrapped back to slot 0`

`1001   |||| 1 || 1`

after `1111`, pointer reset to 0000 and begin again with refreshed `rptr` and `wptr`

## What to do

1. **`sync_fifo.sv`** - implement `empty`, `full`, `do_write`, `do_read`, and the two `always_ff` bodies (`TODO`s).
2. **`test_sync_fifo.py`** - two tests are done for you. Write the other six (each has a docstring saying what to check). The reference model and `cycle()` helper already do the comparing.
3. Run `make`. Read the pass/fail table at the end.
4. `make waves` opens `dump.vcd`. Find the `wptr`/`rptr` signals, watch them wrap around, and watch `full` go high.
5. **Sanity-check your testbench:** temporarily break your FIFO (for example, remove `&& !full` from `do_write`) and confirm at least one test fails. Then undo it.

## Done when

- [ ] `make lint` has no warnings about your logic
- [ ] all 8 tests pass
- [ ] your tests cover: full, empty, write-when-full, read-when-empty, simultaneous read/write, pointer wraparound, and 1000+ random cycles
- [ ] the sanity check in step 5 made a test fail
- [ ] `dump.vcd` is committed

## References

- [ChipVerify: Synchronous FIFO](https://www.chipverify.com/verilog/synchronous-fifo) - a second explanation of the same idea. Its interface and full/empty details may differ from this spec, so follow the spec above, and write your own code rather than copying.
