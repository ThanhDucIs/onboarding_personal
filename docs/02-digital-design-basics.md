# Digital Design Fundamentals

This page is the concepts you need *before* the language. If you already know this material, skim the section headings and jump to the [exercises](#exercises) to confirm. Nothing here needs prior experience.

The goal: by the end you can look at a small circuit and say what it does, whether it is combinational or sequential, and roughly how fast it can run.

---

## 1. Bits and numbers

A digital circuit represents everything with wires that are either `0` or `1` (a **bit**). Groups of bits form **vectors**: an 8-bit vector can hold 2^8 = 256 different patterns. What the pattern *means* is up to us.

**Hexadecimal** is shorthand: one hex digit = 4 bits. `8'b1010_0101` = `8'hA5`.

### Unsigned and two's complement

The same bits can be read two ways:

- **Unsigned:** ordinary binary. 4 bits give 0..15.
- **Two's complement (signed):** the top bit has negative weight. 4 bits give -8..7.

| Bits | Unsigned | Signed (two's complement) |
| --- | --- | --- |
| `0000` | 0 | 0 |
| `0111` | 7 | 7 |
| `1000` | 8 | -8 |
| `1111` | 15 | -1 |

To negate a two's-complement number: **invert all bits, then add 1**. To read a negative one: `1111` inverted is `0000`, plus 1 is `0001`, so `1111` is -1.

Things that trip everyone up, and matter directly in the ALU project:

- **Addition is the same hardware** for signed and unsigned. Only the *interpretation* differs.
- **Comparison is not the same.** `4'b1111` is greater than `4'b0001` if unsigned (15 > 1) but less if signed (-1 < 1). That is the difference between RISC-V `sltu` and `slt`.
- **Sign extension:** to widen a signed number, copy the top bit into the new bits (`4'b1111` -> `8'b1111_1111`, still -1). To widen an unsigned number, pad with zeros.
- **Overflow wraps.** `8'hFF + 8'h01 = 8'h00` in 8 bits: the carry out is discarded.
- **Shifting right** has two flavors. A *logical* shift fills with zeros; an *arithmetic* shift copies the sign bit, which keeps negative numbers negative (`-8 >> 1 = -4`).

---

## 2. Combinational logic

**Combinational logic** has outputs that depend only on the *current* inputs. No memory, no clock. Change an input and, after a short propagation delay, the output changes.

Building blocks:

| Block | What it does |
| --- | --- |
| AND, OR, NOT, XOR, NAND, NOR | basic gates; NAND and NOR are the cheapest in silicon |
| **Multiplexer (mux)** | picks one of several inputs using a select signal. A `case` statement becomes a mux |
| **Decoder** | turns an N-bit code into a one-hot signal (exactly one output high) |
| **Adder** | a full adder adds 3 bits (a, b, carry-in) and gives sum and carry-out; chain 32 of them to add 32-bit numbers |
| **Comparator** | equality or less-than |

Every combinational function can be written as a truth table. A 2:1 mux:

```
sel  a  b | y
 0   x  x |  a      (y = a when sel is 0)
 1   x  x |  b
```

**Propagation delay:** a signal takes time to ripple through gates. The longest chain from any input to any output is the circuit's **critical path** and limits how fast you can use it.

---

## 3. Sequential logic: state and the clock

**Sequential logic** remembers. Its outputs depend on inputs *and* stored state. The storage element is the **D flip-flop**: on each rising edge of the clock, it copies its input `D` into its output `Q` and holds it until the next edge.

```
        ┌──────┐
 D ─────┤      │
        │  DFF ├───── Q
 clk ──►│      │
        └──────┘
   Q takes the value D had at the moment of the rising edge
```

A **register** is a group of flip-flops sharing a clock (a 32-bit register is 32 flip-flops). A **counter** is a register plus an adder that feeds `Q+1` back into `D`. A **shift register** chains flip-flops so data moves one place per clock.

Almost all digital design is **synchronous**: one clock, and all state changes happen at its rising edge. Between edges, combinational logic computes the *next* value:

```
   ┌────────────────────────────────────────────┐
   │                                            │
   ▼                                            │
 registers ──► combinational logic ──► next-state values ──► (captured at next clock edge)
 (state)          (+ inputs)
```

### Latches vs. flip-flops

A **latch** is transparent while its enable is high: its output follows its input continuously. A flip-flop only samples at the clock edge. Latches are legitimate in advanced designs but are almost always a bug in beginner RTL: they appear when you forget to assign a signal in every case of combinational code (see [docs/03-hdl.md](03-hdl.md)). Assume "no latches" as a rule.

### Reset

At power-up, flip-flops hold unknown values. A **reset** forces them to a known state. Two styles:

- **Synchronous reset:** only takes effect on a clock edge. Simple, timing-friendly. (The FIFO project uses this.)
- **Asynchronous reset:** takes effect immediately, regardless of the clock. Useful when the clock may not be running yet. (The UART project uses this.)

Both are typically **active-low** (`rst_n`; low = reset). Either works; what matters is that you know which one a module uses. The choice affects how you write the flip-flop and how you drive reset in a testbench.

---

## 4. Timing: how fast can a circuit run?

Between two flip-flops, the data must get through the combinational logic in time:

- **Setup time:** the data must be stable *before* the clock edge for a small window. If the logic between two flip-flops is too slow, the second flip-flop captures the wrong value.
- **Hold time:** the data must stay stable for a small window *after* the edge, or the flip-flop can capture garbage.

The clock period must be at least: `clock-to-Q delay + longest combinational path + setup time`. So:

- The **critical path** (longest path) sets the maximum clock frequency, **f_max = 1 / period**.
- To go faster, shorten the critical path: split the logic in half and put a register in the middle (**pipelining**). Each half now has half the delay, so the clock can go faster, at the cost of an extra cycle of latency.

Setup violations are fixed by slowing the clock or shortening logic; hold violations are fixed by adding delay. Tools check both automatically (**static timing analysis**, see [docs/06-rtl-to-gds.md](06-rtl-to-gds.md)).

**Metastability and clock-domain crossing (preview):** if a signal changes at the same instant a flip-flop samples it, the flip-flop can settle to a random value or hover in between. This is why signals that cross between two unrelated clocks need special synchronizer circuits (typically two flip-flops in series). You won't need this for the onboarding projects, but if you ever see "CDC" on a project, this is what it means.

---

## 5. Finite state machines (FSMs)

An **FSM** is a sequential circuit with a small, named set of **states**, plus rules for moving between them. It is how you build anything that follows a *sequence*: a protocol, a controller, a processor's control unit.

Three parts:

1. **State register:** flip-flops holding the current state.
2. **Next-state logic:** combinational logic: (current state, inputs) -> next state.
3. **Output logic:** what the circuit outputs in each state.

If outputs depend only on the state, it's a **Moore** machine. If they also depend on current inputs, it's a **Mealy** machine. The UART transmitter is Moore-style.

Example: a machine that outputs `1` whenever the last two inputs were both `1`. Three states, described as a transition table:

| State | Meaning | if `in=0` go to | if `in=1` go to | `out` |
| --- | --- | --- | --- | --- |
| `S0` | last input was 0 (or reset) | `S0` | `S1` | 0 |
| `S1` | exactly one 1 in a row so far | `S0` | `S2` | 0 |
| `S2` | two or more 1s in a row | `S0` | `S2` | 1 |

Every state has an arrow for every input value. A missing arrow is a bug.

Steps to design any FSM:

1. List the states and what each one *means* in plain words.
2. Draw the arrows for every input combination out of every state (missing arrows are bugs).
3. Decide what each state outputs.
4. Only then write code.

Common counter-based pattern (you'll use it in the UART): "stay in this state for N cycles, then move on" = a counter that resets on entering the state and triggers the transition when it reaches N-1.

---

## 6. Memories

A **memory** stores many words and is addressed by index. Small ones (like the FIFO's storage) are built from flip-flops; big ones use dedicated SRAM macros. A **FIFO** adds two pointers (write and read) that step through the memory in a circle, and flags to say when it's empty or full.

---

## Exercises

Do these on paper first. Answers are at the bottom; try before you look.

1. Write the 8-bit two's-complement representation of -5.
2. What is `8'hF0` as an unsigned number? As a signed number?
3. In 8 bits, what is `8'd200 + 8'd100`? What is `8'd200 + 8'd100` if you interpret the inputs and result as signed?
4. Sign-extend `4'b1010` to 8 bits. Zero-extend it. What decimal value does each represent (signed vs. unsigned)?
5. What is `8'b1000_0000 >> 2` (a) logical, (b) arithmetic?
6. Draw a truth table for a 4:1 mux with select bits `s1 s0`. How many 2:1 muxes do you need to build it?
7. A path has 3 ns of logic, the flip-flop clock-to-Q is 0.5 ns, and setup time is 0.5 ns. What is the minimum clock period and maximum frequency?
8. You split that 3 ns of logic into 1.5 ns + 1.5 ns with a register between. What is the new minimum period? What did you pay for it?
9. Draw the state diagram for a machine with input `start` that waits in IDLE, then spends exactly 3 cycles in BUSY (output `busy=1`), then returns to IDLE. How many bits does the counter need?
10. Explain in one sentence why "forgetting the `else`" in combinational code can create a latch.

<details>
<summary>Answers</summary>

1. 5 is `0000_0101`. Invert: `1111_1010`. Add 1: `1111_1011` = `8'hFB`.
2. Unsigned 240. Signed: -16.
3. 300 doesn't fit in 8 bits. It wraps to 300 - 256 = 44 (`8'h2C`). Signed: 200 is `8'hC8` = -56 and 100 is 100, so the true sum is 44, which does fit. The bits are the same (`8'h2C`) and the signed answer is right. Same hardware, different meaning.
4. Sign-extended: `8'b1111_1010` = -6 signed. Zero-extended: `8'b0000_1010` = 10 unsigned. (The original `4'b1010` is -6 signed or 10 unsigned. Each extension preserves its own interpretation.)
5. (a) `8'b0010_0000` (32). (b) `8'b1110_0000` (-32, since `8'b1000_0000` is -128 and -128/4 = -32).
6. Output is `d0,d1,d2,d3` for `s1s0 = 00,01,10,11`. Three 2:1 muxes (two in the first level, one in the second).
7. 0.5 + 3 + 0.5 = 4 ns -> 250 MHz.
8. 0.5 + 1.5 + 0.5 = 2.5 ns -> 400 MHz. You paid one extra cycle of latency and the area of an extra register.
9. States IDLE and BUSY. IDLE -> BUSY when `start`. BUSY -> IDLE when the counter reaches 2 (counts 0, 1, 2 = 3 cycles). The counter needs 2 bits.
10. If a signal isn't assigned on some path, the circuit must "remember" its old value, and memory that isn't clocked is a latch.
</details>

**Checkpoint:** you can do exercises 1-5 and 9 without looking at the answers.
