2026-06-16
Implementing the ALU control module. Starting with R-type instruction decoding
using opcode, funct3, and funct7 fields. Still deciding on a control signal 
encoding scheme for the ALU operations.

**Status:** In progress  
**Next:** Define encoding scheme, then move on to other instruction types (I, S, B, U, J)

2026-06-23
Completed ALU and ALU control logic for all R-type instructions (ADD, SUB, AND, 
OR, XOR, SLL, SRL, SRA, SLT, SLTU). Wrote a testbench covering each operation 
plus edge cases — zero flag, wraparound on overflow, and signed vs unsigned 
shift/comparison behavior (SRA vs SRL, SLT vs SLTU). All tests passing.

**Status:** R-type complete  
**Next:** I-type instructions (ALU control decoding + immediate handling)
