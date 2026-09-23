# What is ASICWRU?

Welcome to ASICWRU!
We are Case Western Reserve University's student-led silicon design team. This document can take you from zero experience with RTL, verification, or physical design work to designing a real chip that gets submitted for tapeout.

## What we actually do

ASICWRU takes designs from concept through physical layout to actual silicon. That means the team works across the full stack of chip design:

- **RTL design** — writing the digital logic in Verilog/SystemVerilog
- **Verification** — proving that logic is correct before it's trusted with silicon
- **Physical design** — synthesis, timing analysis, and place-and-route that turn verified RTL into a real, fabricable layout

We use open-source tools end to end — Verilator (simulation), cocotb(verification), Yosys (synthesis), OpenSTA (static timing analysis), OpenROAD (place-and-route), Magic and Netgen (layout and verification). esigns target open silicon processes (SkyWater 130nm and IHP 130nm) through the Tiny Tapeout program, which is how a student team gets an actual chip fabricated without a corporate budget.

In the future we will work to get our hands on EDA tool, but for now, this open source tool set has everything you need to complete the onboarding process.

**No prior tapeout or chip-design experience is required to join.** The entire point of this onboarding path is built to take someone from zero to strong enough to contribute to a real project.

## What we've built

- A functional 32-bit RISC-V core implementing the base RV32I instruction set
- **Current flagship project:** a configurable FIR filter chip for real-time audio equalization and noise filtering
- **Also in flight:** an open-source protocol emulator ASIC, being built for the Jane Street / Tiny Tapeout ASIC competition

These are the chips this team is going to tape out. Onboarding exists so you can get to contributing on projects like these as fast as possible, with a real foundation under you instead of guessing.

## Weekly General Body Meetings

The team runs **weekly GB meetings** to go over the current state of the club. These meetings will also be times to ask any questions / get extra help withthe onboarding process. It will acts as an offie hour. Current memebers can help cover digital design and SystemVerilog fundamentals Showing up to these consistently is the fastest way through onboarding.

## Where to get help outside of meetings

- **Discord:** `#onboarding-channel` — post here first when you're stuck on anything 


# WHere to Start: Onboarding Roadmap

This is the full path from "just joined" to "contributing on a project team," in order. Estimates assume a few hours a week around classes, plus showing up to weekly sessions

Stuck anywhere on this list? Post in `#onboarding-channel` on Discord

---

## Step 1 — Get your environment working

- [ ] Head to `01-tool-setup.md`
- [ ] Set up Git + GitHub
- [ ] Set up your OS environment (WSL2 on Windows, native on macOS/Linux)
- [ ] Install Python 3, Verilator, cocotb, GTKWave 
- [ ] Set up your editor (VS Code + SystemVerilog extension)

## Step 2 — Digital design fundamentals

- [ ] Head to `02-digital-design-basics.md`

## Step 3 — Verilog / SystemVerilog basics

- [ ] Head to `03-verilog-systemverilog.md`

## Step 4 — Verification basics

- [ ] Head to `04-verification-basics.md`

## Step 5 - RTL-to-GDS ()

- [ ] Head to `05-rtl-to-gds.md`

## Step 6 - Instruction Set Architecture (ISA)

- [ ] Head to `06-isa.md`

## Step 7 —  ALU & Synchrnous FIFO & UART Projects

- Each of these projects has a seperate folder

## Step 8 — Join a project team

- Get in touch with a team lead in discord or at a meeting