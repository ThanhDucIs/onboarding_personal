# Introduction to Instruction Set Architectures (ISA)

### What is an instruction set architecture?

An **instruction set architecture (ISA)** defines the instructions a processor understands and what each instruction does. It also defines things such as the registers available to a program and how instructions are represented in binary.

For example, an ISA might define an `add` instruction that reads two registers and writes their sum to a third register. The ISA tells us what the instruction must do, while the processor designer decides how to build the hardware that carries it out.

---

### RISC vs. CISC

You may see processors described as **RISC (Reduced Instruction Set Computer)** or **CISC (Complex Instruction Set Computer)**. RISC designs generally use simpler instructions, while CISC designs can provide instructions that perform more work in a single instruction. A program may therefore need several RISC instructions to do a task that a CISC ISA expresses with fewer instructions.

**x86-64**, used by most traditional Intel and AMD Windows PCs, is an example of a CISC ISA. Newer Macs with Apple silicon use **Arm**, a RISC-style ISA; older Intel Macs used x86-64. Windows can also run on Arm-based PCs, so the operating system alone does not tell you which ISA a computer uses.

---

### What is RISC-V?

**RISC-V** is an open-standard ISA with a base set of instructions and optional extensions. **RV32I** is its 32-bit base integer instruction set: `RV` refers to RISC-V, `32` means its general-purpose registers are 32 bits wide, and `I` refers to the base integer instructions.

RV32I has 32 integer registers, named `x0` through `x31`. Each register is 32 bits wide, and `x0` always reads as zero. Instructions can use registers to hold values, but the registers themselves are separate hardware from the ALU.

For instance:

```asm
add x3, x1, x2
```

This instruction adds the values in `x1` and `x2`, then writes the result to `x3`. The destination comes first in RISC-V assembly. In a processor, the register file supplies the two input values, the ALU computes the sum, and the result is written back to the destination register.

> For the onboarding ALU project, you only need to implement the operation on two 32-bit inputs. Your ALU does not need to read assembly instructions or contain 32 registers.

---

### RISC-V Instructions

The following **RV32I register-register instructions** use two source registers (`rs1` and `rs2`) and one destination register (`rd`). Here are three examples relevant to an ALU:

| Instruction | Operation | Result written to `rd` |
| --- | --- | --- |
| `add rd, rs1, rs2` | Addition | `rs1 + rs2` |
| `and rd, rs1, rs2` | Bitwise AND | `rs1 & rs2` |
| `sra rd, rs1, rs2` | Arithmetic right shift | Shift `rs1` right and copy its sign bit |

Other ALU operations include `sub` for subtraction, `or` and `xor` for bitwise logic, and `sll` and `srl` for logical shifts. `slt` and `sltu` compare two values and produce either 1 or 0. `slt` treats the inputs as signed, while `sltu` treats them as unsigned.

For the shift instructions, only the lowest five bits of `rs2` specify the shift amount. This gives a shift amount from 0 to 31 for a 32-bit value.

RV32I also has instructions that use a constant value, called an **immediate**, instead of a second register. For example, `addi x3, x1, 5` adds 5 to `x1`. A processor can send the immediate to an ALU input, so the same addition hardware can support both `add` and `addi`.

---

### Examplses

Suppose your ALU has two 32-bit inputs, `a` and `b`, a control input that selects an operation, and a 32-bit output, `result`. Here are some cases you can use to understand or test the design:

| Operation | `a` | `b` | Expected `result` |
| --- | --- | --- | --- |
| ADD | `32'd12` | `32'd5` | `32'd17` |
| AND | `32'h0000000F` | `32'h00000033` | `32'h00000003` |
| SRA | `32'h80000000` | `32'd1` | `32'hC0000000` |

You can test the other operations in the same way. For example, subtracting 5 from 12 should produce 7, and shifting `32'h80000000` right by one with `srl` should produce `32'h40000000`. With `sra`, the same inputs produce `32'hC0000000` because the upper bit stays 1.

For a signed comparison, `32'hFFFFFFFF` represents `-1`, so `slt` returns 1 when comparing it with 1. As an unsigned value, those same bits represent `4,294,967,295`, so `sltu` returns 0. For 32-bit addition and subtraction, the result keeps only the lowest 32 bits if it overflows. For example, `32'hFFFFFFFF + 32'd1` produces `32'h00000000`.

You can look more into the RISC-V instruction set here: [official RV32I specification](https://docs.riscv.org/reference/isa/v20260120/unpriv/rv32.html).

