# Introduction to FPGAs and ASICs

### What is an FPGA?

A field-programmable gate array (FPGA) is a chip whose digital logic can be reconfigured after it is manufactured. You can write a design in Verilog or SystemVerilog, compile it into a bitstream, and load that bitstream onto the FPGA. If you need to change your circuit, you can update the design and load a new bitstream. An FPGA is useful for its flexibility, allowing you to prototype and debug much quickly.

There are two leading FPGA vendors: AMD (Xilinx) and Intel (Altera) and each company has different suite of tools that you must use if you're working with their hardware.

---

### What is an ASIC?

An application-specific integrated circuit (ASIC) is manufactured for a particular design. Once it has been fabricated, you cannot reprogram its logic the way you can with an FPGA. 

An ASIC can be designed for a specific task, such as processing data or controlling another device. ASICs can run much faster and handle higher clock frequencies even while using less power if optimized for Power, Performance, and Area (PPA).

The design must be checked carefully before fabrication because changing it afterward requires manufacturing a new chip, which is a very expensive process that can cost up to millions of dollars.

---

### FPGA vs. ASIC

| | FPGA | ASIC |
| --- | --- | --- |
| Changing the design | Load a new bitstream | No, the design is hardwired on silucon  |
| Getting hardware | Obtain an FPGA from a vendor | Fabricate the design through a foundry (TSMC, Samsung, etc.) |
| Main advantage | Reprogrammability, faster to test and revise | Can be optimized for the design's area, speed, and power and cheaper when manufactured in higher volume |

Both can start with RTL written in an HDL, but they have different implementation flows. On an FPGA, the tools map your design to the chip's existing programmable resources. For an ASIC, the tools turn your design into a layout of cells and wires that can be manufactured and taped out by a foundry. In ASICWRU, we'll be using FPGAs for prototyping and early demonstrations, and then submitting our designs to Tiny Tapeout once our design is fully verified to be functional and meets our set standards.

---

### What is Tiny Tapeout?

[Tiny Tapeout](https://tinytapeout.com/) is an initiative that lets students and hobbyists submit small designs to be fabricated on actual silicon through open-source tools and without spending millions of dollars. This makes it possible to go through a real chip-design process with a small project. Multiple projects share space on one chip, with each project occupying a small area called a tile. A tile can contain roughly fit ~1,000 logic gates, and this depends on which Process Development Kit (PDK) you're using. Tiny Tapeout mainly has shuttles of different PDKs where you can submit your design. 

For a project, you can write your RTL, simulate and test it, then Tiny Tapeout uses the OpenLane flow to automate the process of turning the design into a physical layout for fabrication. After the chip is manufactured, you can test how your circuit behaves in silicon.

For more detail, see Tiny Tapeout's [Making ASICs](https://tinytapeout.com/making_asics/) and [FPGA to ASIC](https://tinytapeout.com/hdl/fpga_vs_asic/) pages.
