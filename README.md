# Welcome to ASICWRU!

We are Case Western Reserve University's student-led silicon design team. This repository can take you from zero experience with RTL, verification, or physical design work to being ready to contribute to a real chip that gets submitted for tapeout.

## What we actually do

ASICWRU takes designs from concept through physical layout to actual silicon. That means the team works across the full stack of chip design:

- **RTL design** — writing the digital logic in Verilog/SystemVerilog
- **Verification** — proving that logic is correct before it's trusted with silicon
- **Physical design** — synthesis, timing analysis, and place-and-route that turn verified RTL into a real, fabricable layout

We use open-source tools for the entire design flow: Verilator (simulation), cocotb (verification), Yosys (synthesis), OpenSTA (static timing analysis), OpenROAD (place-and-route), and Magic and Netgen (layout and verification). Designs target open silicon processes (SkyWater 130nm and IHP 130nm) through the Tiny Tapeout program, which is how a student team gets an actual chip fabricated without a corporate budget.

In the future we will work to get our hands on commercial EDA tools, but for now, this open-source tool set has everything you need to complete the onboarding process.

**No prior tapeout or chip-design experience is required to join.** This onboarding path is built to take someone from zero to strong enough to contribute to a real project.

## What we've built

- A functional 32-bit RISC-V core implementing the base RV32I instruction set
- **Current flagship project:** a configurable FIR filter chip for real-time audio equalization and noise filtering
- **Also in flight:** an open-source protocol emulator ASIC, being built for the Jane Street / Tiny Tapeout ASIC competition

These are the chips this team is going to tape out. Onboarding exists so you can get to contributing on projects like these as fast as possible, with a real foundation under you instead of guessing.

## Weekly General Body Meetings

The team runs **weekly GB meetings** to go over the current state of the club. These meetings are also a time to ask questions and get extra help with the onboarding process; think of them as office hours. Current members can help cover digital design and SystemVerilog fundamentals. Showing up consistently is the fastest way through onboarding.

## Where to get help outside of meetings

- **Discord:** `#onboarding-channel` — post here first when you're stuck on anything. Include what you ran, what you expected, and the exact error text.

---

# Where to Start: Onboarding Roadmap

This is the full path from "just joined" to "contributing on a project team," in order. Estimates assume a few hours a week around classes, plus showing up to weekly sessions.

---

## Step 1 — Get your environment working

- [ ] Head to `docs/01-setup.md`
- [ ] Set up your OS environment (WSL2 on Windows, native on macOS/Linux)
- [ ] Install Verilator (5.036 or newer), Python 3, cocotb, GTKWave
- [ ] Set up Git + GitHub and fork this repository
- [ ] Set up your editor (VS Code + SystemVerilog extension)

## Step 2 — Digital design fundamentals

- [ ] Head to `docs/02-digital-design-basics.md`

## Step 3 — Verilog / SystemVerilog basics

- [ ] Head to `docs/03-hdl.md`

## Step 4 — Verification basics

- [ ] Head to `docs/04-verification-basics.md`

## Step 5 — FPGAs, ASICs, and Tiny Tapeout

- [ ] Head to `docs/05-fpga-asic.md`

## Step 6 — RTL-to-GDS

- [ ] Head to `docs/06-rtl-to-gds.md`

## Step 7 — Instruction Set Architecture (ISA)

- [ ] Head to `docs/07-isa.md`

## Step 8 — ALU, Synchronous FIFO, and UART projects

Read `docs/08-onboarding-modules.md`, then do the projects in this order:

- [ ] ALU Project: head to `alu/`
- [ ] Synchronous FIFO Project: head to `sync_fifo/`
- [ ] UART Transmitter Project: head to `uart_transmitter/`

## Step 9 — Join a project team

- Get in touch with a team lead in Discord or at a meeting

Extra reading and videos: `docs/09-resources.md`.
