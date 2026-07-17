# RV32I Pipelined CPU

A 5-stage pipelined RISC-V CPU implementing the RV32I base integer ISA, written
in synthesizable Verilog and verified in simulation with Icarus Verilog.

## Overview

This project started as a single-cycle RV32I datapath and was rebuilt into a
5-stage pipeline (IF, ID, EX, MEM, WB) with full data-hazard resolution via
forwarding and load-use stalling. Every module was built and unit-tested in
isolation before being integrated, and the full pipeline is verified against a
hand-assembled test program exercising every instruction type.

## Features

- Full RV32I instruction support: R-type, I-type (including shifts with their
  special funct7-style encoding), loads, stores, branches, JAL, JALR, LUI,
  AUIPC
- 5-stage pipeline: Fetch → Decode → Execute → Memory → Writeback
- Data forwarding from EX/MEM and EX/MEM/MEM/WB into the EX stage, with
  correct priority when both sources match
- Load-use hazard detection with automatic pipeline stalling
- Byte-addressed, little-endian instruction and data memory
- Dedicated branch comparator supporting all six branch conditions
  (signed and unsigned comparisons handled explicitly)

## Pipeline Stages

```
IF  →  ID  →  EX  →  MEM  →  WB
```

- **IF** — PC register and instruction memory fetch the next instruction
- **ID** — instruction is decoded: register file read, immediate generation,
  control signal generation, branch condition evaluated
- **EX** — ALU executes; forwarding muxes resolve data hazards from later
  pipeline stages before the ALU operands are selected
- **MEM** — data memory is read or written for loads/stores
- **WB** — result is selected (ALU result, memory data, PC+4, or immediate
  bypass for LUI) and written back to the register file

## Hazard Handling

- **Data hazards (RAW)** — resolved by forwarding from EX/MEM and MEM/WB
  directly into the EX stage's ALU operand muxes, avoiding stalls in the
  common case
- **Load-use hazards** — detected when the instruction in EX is a load whose
  destination matches an operand of the instruction right behind it in ID;
  resolved with a one-cycle pipeline stall and bubble insertion
- **Control hazards** — branch and jump targets resolved during EX/decode;
  incorrect fetches are handled via flush logic in the pipeline registers

## Module List

| Module | Description | Status |
|---|---|---|
| `alu.v` / `alu_ctrl.v` / `alu_top.v` | Arithmetic/logic unit and operation decode | Tested |
| `regfile.v` | 32×32-bit register file, x0 hardwired to zero | Tested |
| `immgen.v` | Immediate generation for all five instruction formats | Tested |
| `control.v` | Opcode-driven control signal generation | Tested |
| `pc_reg.v` | Program counter with synchronous reset | Tested |
| `imem.v` | Byte-addressed instruction memory | Tested |
| `dmem.v` | Byte-addressed data memory (word-level load/store) | Tested |
| `branch_unit.v` | Branch condition evaluation (all six branch types) | Tested |
| `if_id_reg.v` / `id_ex_reg.v` / `ex_mem_reg.v` / `mem_wb_reg.v` | Pipeline registers | Tested |
| `forwarding_unit.v` | RAW hazard detection and forwarding source selection | Tested |
| `hazard_unit.v` | Load-use hazard detection and stall control | Tested |
| `cpu_top.v` | Full pipelined datapath, all modules wired together | Tested |

## Building and Simulating

Requires [Icarus Verilog](http://bleyer.org/icarus) and GTKWave for waveform
viewing.

```bash
# Compile a testbench (example: full CPU integration test)
iverilog -o tb_cpu_top_sim \
  rtl/fetch/pc_reg.v rtl/fetch/imem.v \
  rtl/decode/regfile.v rtl/decode/immgen.v \
  rtl/control/control.v \
  rtl/execute/alu.v rtl/execute/alu_ctrl.v rtl/execute/alu_top.v rtl/execute/branch_unit.v \
  rtl/memory/dmem.v \
  rtl/pipeline/if_id_reg.v rtl/pipeline/id_ex_reg.v rtl/pipeline/ex_mem_reg.v rtl/pipeline/mem_wb_reg.v \
  rtl/hazard/forwarding_unit.v rtl/hazard/hazard_unit.v \
  rtl/cpu_top.v \
  tb/tb_cpu_top.v

# Run
vvp tb_cpu_top_sim
```

Each module also has its own standalone testbench under `tb/` for unit-level
verification.

## Directory Structure

```
rtl/
├── cpu_top.v
├── control/
│   └── control.v
├── decode/
│   ├── regfile.v
│   └── immgen.v
├── execute/
│   ├── alu.v
│   ├── alu_ctrl.v
│   ├── alu_top.v
│   └── branch_unit.v
├── fetch/
│   ├── pc_reg.v
│   └── imem.v
├── memory/
│   └── dmem.v
├── pipeline/
│   ├── if_id_reg.v
│   ├── id_ex_reg.v
│   ├── ex_mem_reg.v
│   └── mem_wb_reg.v
└── hazard/
    ├── forwarding_unit.v
    └── hazard_unit.v

tb/
└── ... one testbench per module, plus tb_cpu_top.v for full integration

docs/
└── notes on the ISA, pipeline design, and study references
```

## Status

Pipelined CPU complete: full instruction support, forwarding, and load-use
stalling all implemented and passing tests.

## Roadmap / Possible Extensions

- Byte and halfword load/store variants (`lb`, `lh`, `sb`, `sh`)
- Branch prediction to reduce control-hazard penalty
- M-extension (multiply/divide)
- Synthesis and FPGA deployment