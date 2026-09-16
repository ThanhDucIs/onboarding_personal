# Introduction to Hardware Description Language (HDL)

### What is a hardware description language?

A **hardware description language (HDL)** is a special type of programming language created specifically for describing and simulating the structure and behavior of digital logic circuits. Popular HDLs include Verilog, SystemVerilog, and VHDL.
Verilog has a C-like syntax (similar operators, if-else structures, etc.) but their underlying behavior is completely different. Verilog operates in parallel, which means multiple blocks of code can run at the same time like an electronic circuit.
On the other hand, C code executes the code sequentially.


SystemVerilog is an extension of Verilog with extra features such as more data types (e.g logic, struct, and enum) and advanced verification features. Syntax-wise, they're still the same so you shouldn't worry about missing out on it while learning Verilog.

--- 

### How do I learn Verilog?

To learn the basics of Verilog, you're recommended to check out [HDLBits](hdlbits.01xz.net) which provides over 150+ Verilog exercises from learning how to create an AND gate to shift registers. However, you won't need to go through all of the exercises there.
We've highlighted some of the exercises that are going to be relevant for the onboarding projects.

You can access all the problems from [here](https://hdlbits.01xz.net/wiki/Problem_sets).

| # | Topic | Problem(s) |
| --- | --- | --- |
| 1 | Getting Started |  Getting Started, Output Zero |
| 2 |  Basics | Simple wire, Four wires, Inverter, AND Gate, NOR Gate, Declaring wires |
| 3 | Vectors | Vectors, Vectors in more detail, Bitwise operators, Vector concatenation operator|
| 4 | Modules: Hierarchy | Modules, Three modules, Modules and vectors, Adder 1|
| 5 | Procedures | All exercises besides the priority encoder exercises |
| 6 | More Verilog Features | Conditional ternary operator |
| 7 | Combinational Logic | Basic Gates, Multiplexers, Adders, Karnaugh Map exercises |
| 8 | Sequential Logic | D Flip-Flops, Registers, Counters, Shift Registers |
| 9 |  Finite State Machines | Simple FSM exercises and FSM design |

<br>

> HDLBits primarily teaches you the ``wire`` and ``reg`` signal types. For the onboarding project which is in SystemVerilog, you can use the ``logic`` data type in place of either instead.

> In SystemVerilog, use ``always_comb`` instead of ``always`` for combinational logic. Similarly, use ``always_ff`` for sequential circuits to avoid confusion.

---

### Testbenches

A **testbench** is code used to test and verify that your Verilog/SystemVerilog module works correctly. Unlike your actual design, the testbench is not synthesized into hardware.

Instead, the testbench provides inputs to your module and checks its outputs.

For example, if you created an AND gate:

```systemverilog
module and_gate (
    input  logic a,
    input  logic b,
    output logic y
);

assign y = a & b;

endmodule
```

A simple testbench could look like:

```systemverilog
module and_gate_tb;

logic a;
logic b;
logic y;

and_gate dut (
    .a(a),
    .b(b),
    .y(y)
);

initial begin
    a = 0;
    b = 0;

    #10;
    a = 0;
    b = 1;

    #10;
    a = 1;
    b = 0;

    #10;
    a = 1;
    b = 1;

    #10;
    $finish;
end

endmodule
```

The module being tested is commonly called the **DUT (Design Under Test)**. The `#10` tells the simulator to wait 10 units of simulation time before moving on to the next input. The `$finish` statement ends the simulation. For larger projects, testbenches can automatically check outputs instead of requiring you to manually look at waveforms.

---

### Non-blocking vs. blocking statements

Blocking vs. Non-Blocking Assignments

There are two common types of assignments you will see in SystemVerilog:

Generally, ``=`` is a blocking assignment used for combinational logic while ``<=`` is a non-blocking assignment used for sequential logic.

Blocking assignments happen in order. Each line can see the result of the line before it while non-blocking assignments calculate their new values first, then update them together.

For example:

```systemverilog
always_ff @(posedge clk) begin
    q1 <= data;
    q2 <= q1;
end
```

On the clock edge, ``q1`` receives data while ``q2`` receives the previous value of q1.
