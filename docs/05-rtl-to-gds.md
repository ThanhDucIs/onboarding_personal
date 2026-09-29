# RTL-to-GDS

RTL-to-GDS (or RTL-to-GDSII) is the name given defining the complete chip design process all the way from describing the RTL all the way to exporting the GDS II to submit to a foundry for tapeout.

## The flow, end to end

```
RTL (SystemVerilog)
   │
   ▼  synthesis (Yosys)
gate-level netlist
   │
   ▼  floorplanning
chip floorplan (die size, macro/IO placement)
   │
   ▼  placement
standard cells placed on the floorplan
   │
   ▼  clock tree synthesis (CTS)
clock distributed to every flip-flop with balanced delay
   │
   ▼  routing
metal wires connecting everything
   │
   ▼  static timing analysis (OpenSTA) — checked throughout, not just at the end
   │
   ▼  DRC / LVS
design rule check + layout-vs-schematic verification
   │
   ▼
GDSII → tapeout
```

Each stage takes the previous stage's output as input. A bug or bad decision early (e.g. a design that doesn't meet timing at synthesis) gets more expensive to fix the further down this pipeline you are.

## Synthesis (Yosys)

Synthesis translates your RTL (behavioral SystemVerilog — `always_ff`, `case` statements, etc.) into a **gate-level netlist**. This is a graph of actual logic gates (AND, OR, flip-flops, muxes) drawn from a **standard cell library**; the physical building blocks available in the target process. This is also where a lot of logic optimization happens: redundant logic gets removed, and the tool tries to meet your area/timing targets using the cheapest set of gates that implements your logic correctly.

Yosys is the open-source synthesis tool ASICWRU uses. It reads RTL and a cell library and emits a netlist ready for the next stage.

## Static timing analysis (OpenSTA)

Once you have gates, you need to know: **how fast can this design actually run?**

STA checks every timing path in the design from one flip-flop, through combinational logic, to the next flip-flop against two constraints:

- **Setup time** — data has to arrive at the next flip-flop early enough before the clock edge
- **Hold time** — data has to stay stable long enough after the clock edge

The path with the least slack (margin) is the **critical path**, and it sets the maximum clock frequency the chip can run at. 

OpenSTA is run throughout physical design (not just once at the end). If placement or routing makes a path too long, you'll see it here before it becomes a silent failure in real silicon.

## Place & route (OpenROAD)

This is where the gate-level netlist becomes an actual physical layout:

- **Floorplanning** — decide the chip's overall dimensions and where major blocks/IO pins go
- **Placement** — assign every standard cell an actual (x, y) location on the die
- **Clock tree synthesis (CTS)** — build a distribution network so the clock reaches every flip-flop with minimal skew (arrival-time difference) — this matters directly for the setup/hold margins STA checks
- **Routing** — draw the actual metal wires connecting every net, across multiple metal layers

OpenROAD handles this whole sequence. The output is a layout — real geometry, not an abstract netlist anymore.

## PDKs and process nodes

A **PDK** (process design kit) is everything a specific fab process gives you to design for it: the standard cell library, design rules (minimum wire widths, spacing, via rules), device models, and everything else needed to go from a netlist to something that can actually be manufactured on that process.

ASICWRU targets two 130nm processes:

- **SkyWater 130nm (SKY130)** — the original open-source PDK behind most Tiny Tapeout submissions
- **IHP 130nm (IHP SG13G2 / CMOS5L)** — a newer open PDK, used for projects like the protocol emulator

"130nm" refers to the minimum feature size the process can reliably manufacture — large by modern commercial standards (cutting-edge commercial chips are single-digit nanometers), but more than capable for the digital designs ASICWRU builds, and critically, it's a process with an open, freely usable PDK — which is what makes student tapeouts possible at all.

## DRC and LVS

Before a layout can be submitted, it has to pass two checks:

- **DRC (design rule check)** — does every shape in the layout obey the process's manufacturing rules (minimum spacing, minimum width, etc.)? A DRC violation means the fab may not be able to reliably manufacture that part of the layout.
- **LVS (layout vs. schematic)** — does the actual layout's connectivity match the netlist it was supposed to implement? This catches routing bugs — a wire connected to the wrong net, a missing connection — that wouldn't show up in DRC.

Magic and Netgen are the open-source tools ASICWRU uses for DRC and LVS respectively.

## Tapeout and Tiny Tapeout

"Tapeout" is submitting your final, DRC/LVS-clean layout (as a **GDSII** file — the standard format describing the physical layout) for actual fabrication. Historically this required a company-scale budget; **Tiny Tapeout** changes that by aggregating many small designs from different teams onto one shared multi-project wafer, splitting the fabrication cost across everyone on it.

This is the team's real, deadline-driven output — the Flagship FIR filter and the protocol emulator both funnel through this exact flow, ending in an actual chip that comes back from the fab with your logic on it.

## Further reading

- [Yosys documentation](https://yosyshq.net/yosys/documentation.html)
- [OpenROAD documentation](https://openroad.readthedocs.io/)
- [OpenSTA documentation](https://github.com/parallaxsw/OpenSTA)
- [Tiny Tapeout docs](https://tinytapeout.com/) — especially their own flow walkthrough, since that's the exact path ASICWRU submissions take