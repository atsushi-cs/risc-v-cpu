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