module forwarding_unit (
    input [4:0] rd_exmem,
    input reg_write_exmem,
    input [4:0] rd_memwb,
    input reg_write_memwb,
    input [4:0] rs1_idex,
    input [4:0] rs2_idex,
    output reg [1:0] forward_a,
    output reg [1:0] forward_b
);

    always @(*) begin
        if (reg_write_exmem && rd_exmem != 0 && rd_exmem == rs1_idex) begin
            forward_a = 2'b01;
        end else if (reg_write_memwb && rd_memwb != 0 && rd_memwb == rs1_idex) begin
           forward_a = 2'b10; 
        end else begin
            forward_a = 2'b0;
        end

        if (reg_write_exmem && rd_exmem != 0 && rd_exmem == rs2_idex) begin
            forward_b = 2'b01;
        end else if (reg_write_memwb && rd_memwb != 0 && rd_memwb == rs2_idex) begin
           forward_b = 2'b10; 
        end else begin
            forward_b = 2'b0;
        end
    end
endmodule