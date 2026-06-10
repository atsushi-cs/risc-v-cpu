## Overview
A 5-stage pipelined RISC-V CPU implementing the RV32I base integer ISA, 
written in synthesizable Verilog. Supports all 37 RV32I instructions with 
full data hazard resolution via forwarding and stall logic. Branch outcomes 
are resolved in the EX stage to minimize flush penalty. Tested against a 
custom RISC-V assembly test suite and verified on a Basys3 FPGA.
