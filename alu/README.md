# Module 1: 32-bit ALU

**Concepts practiced:** combinational logic, `case` → multiplexer, latch avoidance, signed vs. unsigned, logical vs. arithmetic shifts, self-checking testbenches, randomized testing.

**Prerequisites:** [docs/02-digital-design-basics.md](../docs/02-digital-design-basics.md), [docs/03-hdl.md](../docs/03-hdl.md), [docs/07-isa.md](../docs/07-isa.md) (RV32I ALU operations).

## Interface (fixed - do not rename)

| Port | Dir | Width | Meaning |
| --- | --- | --- | --- |
| `a` | in | 32 | first operand |
| `b` | in | 32 | second operand (shifts use only `b[4:0]`) |
| `op` | in | 4 | operation select |
| `result` | out | 32 | result |

The ALU is purely combinational: no clock, no reset.

## Opcodes

These ten operations are the RV32I register-register ALU operations.

| `op` | Name | `result` |
| --- | --- | --- |
| `4'h0` | ADD | `a + b` (wraps at 32 bits) |
| `4'h1` | SUB | `a - b` (wraps at 32 bits) |
| `4'h2` | AND | `a & b` |
| `4'h3` | OR | `a \| b` |
| `4'h4` | XOR | `a ^ b` |
| `4'h5` | SLL | `a` shifted left (logical) by `b[4:0]` |
| `4'h6` | SRL | `a` shifted right (logical, zero fill) by `b[4:0]` |
| `4'h7` | SRA | `a` shifted right (arithmetic, sign fill) by `b[4:0]` |
| `4'h8` | SLT | `1` if `a < b` treating both as **signed**, else `0` |
| `4'h9` | SLTU | `1` if `a < b` treating both as **unsigned**, else `0` |
| `4'hA`-`4'hF` | (invalid) | `0` |

`SLT`/`SLTU` return a full 32-bit result: `32'd1` or `32'd0`.

## Worked examples

| Op | `a` | `b` | `result` |
| --- | --- | --- | --- |
| ADD | `32'd12` | `32'd5` | `32'd17` |
| ADD | `32'hFFFFFFFF` | `32'd1` | `32'h00000000` |
| SUB | `32'd5` | `32'd12` | `32'hFFFFFFF9` |
| SRL | `32'h80000000` | `32'd1` | `32'h40000000` |
| SRA | `32'h80000000` | `32'd1` | `32'hC0000000` |
| SLL | `32'd1` | `32'd32` | `32'd1` (shift amount is `32 & 31 = 0`) |
| SLT | `32'hFFFFFFFF` | `32'd1` | `32'd1` (-1 < 1) |
| SLTU | `32'hFFFFFFFF` | `32'd1` | `32'd0` (4294967295 < 1 is false) |

## What to do

1. **`alu.sv`** - fill in the opcode table and the `case` branches. Every branch marked `TODO`.
2. **`tb_alu.sv`** - fill in the opcode table, the reference `case` inside `check_op`, the directed tests, the invalid-opcode loop, and the random loop. Comments in the file list the cases you must include.
3. **Run it**: `make`. A passing run prints `PASS: all N checks passed` and writes `alu.vcd`.
4. **Look at the waveform**: `make waves`. Find the `SRL` and `SRA` checks on `32'h80000000` and confirm you can *see* the difference in `result`.
5. **Sanity-check your testbench.** A testbench that cannot fail is useless. Temporarily break your ALU (e.g., change `SRA` to use `>>` instead of `>>>`) and confirm `make` reports failures. Then undo the change.

## Done when

- [ ] `make lint` reports no warnings on `alu.sv`
- [ ] `make` exits successfully and prints the PASS line
- [ ] Your testbench includes: at least one directed case per operation, `SRL` vs. `SRA` and `SLT` vs. `SLTU` on inputs where the answers differ, the shift-by-32 case, all six invalid opcodes, and 1000+ random cases
- [ ] You did the sanity check in step 5 and your testbench caught the bug
- [ ] `alu.vcd` is committed

## Hints if you get stuck

- `a < b` on `logic` vectors is *unsigned*. `$signed(a) < $signed(b)` is signed.
- `a >>> n` is only an arithmetic shift if `a` is signed. Write `$signed(a) >>> n`.
- `{31'b0, cond}` builds a 32-bit `0` or `1` from a 1-bit condition.
- If lint says `LATCH` or `CASEINCOMPLETE`, you're missing a `default` or a branch.
