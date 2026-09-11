# Introduction to Hardware Description Language (HDL)

### What is a hardware description language?

A **hardware description language (HDL)** is a special type of programming language created specifically for describing and simulating the structure and behavior of digital logic circuits. Popular HDLs include Verilog, SystemVerilog, and VHDL.
Verilog has a C-like syntax (similar operators, if-else structures, etc.) but their underlying behavior is completely different. Verilog operates in parallel, which means multiple blocks of code can run at the same time like an electronic circuit.
On the other hand, C code executes the code sequentially.


SystemVerilog is an extension of Verilog with extra features such as more data types (e.g logic, struct, and enum) and advanced verification features. Syntax-wise, they're still the same so you shouldn't worry about missing out on it while learning Verilog.

--- 

### How do I learn Verilog?

To learn the basics of Verilog, you're recommended to check out [HDLBits](hdlbits.01xz.net) which provides over 150+ Verilog exercises to learning how to create an AND gate to shift registers. However, you won't need to go through all of the exercises there.
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
| 7 | Combinational Logic |  |
| 8 | Sequential Logic |  |
| 9 |  Finite State Machines | |

<br>

> HDLBits primarily teaches you the ``wire`` and ``reg`` signal types. For the onboarding project which is in SystemVerilog, you can use the ``logic`` data type in place of either instead.

> In SystemVerilog, use ``always_comb`` instead of ``always`` for combinational logic. Similarly, use ``always_ff`` for sequential circuits to avoid confusion.

---

### Testbenches




