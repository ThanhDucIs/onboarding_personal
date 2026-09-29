# Onboarding Projects

You will complete three onboarding modules. Write the RTL yourself without using AI to generate it. For each module, write a testbench, run a simulation, and open the resulting waveforms in GTKWave to check its behavior.
For your testbenches, add a `dumpfile` and `dumpvars` to generate the waveforms from your testbench.

---

### 32-bit ALU

The **arithmetic logic unit (ALU)** takes two 32-bit operands, `a` and `b`, and a control input that selects the operation. Reference the [RV32I ISA](https://docs.riscv.org/reference/isa/v20260120/unpriv/rv32.html) and implement the ten basic operations.

Your SystemVerilog testbench should be written in check each operation, including the difference between signed and unsigned comparisons and between logical and arithmetic right shifts.

---

### UART Transmitter

A **UART transmitter** sends data one bit at a time over a serial output. Implement a transmitter that sends a start bit, eight data bits (least significant bit first), and a stop bit at the selected baud rate. Include a signal that indicates when the transmitter is busy.

Your cocotb testbench should check the order and timing of the transmitted bits.

---

### Synchronous FIFO

A **first-in, first-out (FIFO)** buffer stores data and returns it in the same order it was written. Implement a synchronous FIFO with one clock, read and write controls, and `full` and `empty` status signals.

Your cocotb testbench should check normal reads and writes, the order of stored values, and what happens when the FIFO is full or empty.

---

### Submission

Send the link to your cloned GitHub repository (it must be public!) containing the `.sv` files , a testbench for each module (cocotb/SystemVerilog), and the .vcd waveform files from your simulations.
