## 2026-06-16
Implementing the ALU control module. Starting with R-type instruction decoding
using opcode, funct3, and funct7 fields. Still deciding on a control signal 
encoding scheme for the ALU operations.

**Status:** In progress  
**Next:** Define encoding scheme, then move on to other instruction types (I, S, B, U, J)

## 2026-06-23
Completed ALU and ALU control logic for all R-type instructions (ADD, SUB, AND, 
OR, XOR, SLL, SRL, SRA, SLT, SLTU). Wrote a testbench covering each operation 
plus edge cases — zero flag, wraparound on overflow, and signed vs unsigned 
shift/comparison behavior (SRA vs SRL, SLT vs SLTU). All tests passing.

**Status:** R-type complete  
**Next:** I-type instructions (ALU control decoding + immediate handling)

## 2026-07-09
Completed the control unit — decodes opcode into all datapath control signals 
(reg_write, alu_src, mem_read, mem_write, mem_to_reg, branch, jump). Extended 
the design mid-build to handle two edge cases: added a second ALU-source signal 
(alu_src_a) to let AUIPC use PC instead of a register as the first ALU operand, 
and widened mem_to_reg to 2 bits to support a 4-way writeback mux (ALU result / 
memory / PC+4 / immediate bypass for LUI). Wrote and passed a full testbench 
covering every instruction type plus the default case.

**Status:** ALU, register file, immediate generator, and control unit all 
complete and tested — every standalone module for the single-cycle datapath is done.  
**Next:** Build PC register and instruction/data memory, then wire everything 
together in cpu_top for a working single-cycle CPU.

## 2026-07-16
Completed the full single-cycle RV32I datapath and began pipelining.

**Modules built and unit-tested:**
- PC register (synchronous reset, loads pc_next each cycle)
- Instruction memory — byte-addressed, little-endian, parameterized MEM_FILE for loading hex programs
- Data memory — byte-addressed, little-endian, word-level load/store (lb/lh/sb/sh deferred)
- Branch unit — self-contained comparator for all six branch types (beq/bne/blt/bge/bltu/bgeu), signed vs. unsigned handled explicitly rather than relying on ALU reuse

**cpu_top — full single-cycle datapath wired and integration tested:**
- PC → instruction memory → instruction field slicing → regfile/immgen/control/branch_unit
- Asel/Bsel muxes for ALU operands (PC vs register, immediate vs register), supporting AUIPC's PC-relative addressing
- ALU → data memory → 4-way writeback mux (ALU result / memory / PC+4 / immediate bypass for LUI)
- Next-PC logic distinguishing JALR (register-relative target, LSB cleared per spec) from JAL/branch (PC-relative target)
- Verified with a hand-assembled 17-instruction test program exercising every instruction type (R, I, load, store, both branch outcomes, JAL, JALR, LUI, AUIPC) — all register and memory checks passed

**Pipelining — started:**
- Built and tested the IF/ID pipeline register (latches pc_current and instruction across the clock edge, synchronous reset)

**Status:** Single-cycle CPU complete and fully verified. Pipelining underway.  
**Next:** ID/EX, EX/MEM, MEM/WB pipeline registers, then restructure cpu_top 
to use them (expect incorrect results on dependent instructions until hazard 
detection/forwarding is added).

## 2026-07-16 (cont.)
Built the remaining pipeline registers — ID/EX, EX/MEM, and MEM/WB — completing 
the full 4-stage pipeline register chain (IF/ID → ID/EX → EX/MEM → MEM/WB). 
Each register latches its stage's relevant data and control signals forward 
on the clock edge, with synchronous reset clearing all outputs to 0.

**Status:** All four pipeline registers built. cpu_top still needs to be 
restructured to actually route signals through them instead of the single-cycle 
combinational wiring.  
**Next:** Rewire cpu_top to use the pipeline registers end-to-end. Expect 
incorrect results on programs with data dependencies (RAW hazards) and 
branches/jumps until forwarding, hazard detection, and proper branch-resolution 
timing are added — that's the work right after this.

## 2026-07-16 (cont.)
Rewired cpu_top to route signals through the four pipeline registers 
(IF/ID → ID/EX → EX/MEM → MEM/WB) instead of single-cycle combinational 
wiring. Tested basic pipeline flow with spaced-out instructions (no 
dependencies) — confirmed correct. As expected, back-to-back dependent 
instructions and branches/jumps currently give wrong results, since 
forwarding and hazard/flush logic don't exist yet.

Built and tested the forwarding unit — detects RAW hazards independently 
for rs1 and rs2 against both EX/MEM and MEM/WB, with EX/MEM given priority 
when both match, and the x0 exception handled. Full test suite covering 
no-hazard, single-source hazards, dual-match priority, x0 exclusion, 
reg_write gating, and an independent-outputs cross-check — all passing.

**Status:** Pipeline restructured and verified for independent instructions. 
Forwarding unit complete and tested, not yet wired into cpu_top.  
**Next:** Add the forwarding muxes in cpu_top (select between regfile value, 
EX/MEM result, MEM/WB result using forward_a/forward_b), then build the 
hazard detection unit for load-use stalls and branch/jump flush logic.
