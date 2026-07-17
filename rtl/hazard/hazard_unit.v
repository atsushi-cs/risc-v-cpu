module hazard_unit (
    input [4:0] rs1_id,
    input [4:0] rs2_id,
    input [4:0] rd_ex,
    input       mem_read_ex,
    output      stall
);

    assign stall = mem_read_ex && (rd_ex != 0) && ((rd_ex == rs1_id) || (rd_ex == rs2_id));

endmodule
