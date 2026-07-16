module id_ex_reg (
    input clk,
    input reset,
    
    input [31:0] rdata1_in,
    input [31:0] rdata2_in,
    input [31:0] immediate_in,
    input [31:0] pc_current_in,
    input alu_src_in,
    input alu_src_a_in,
    input [4:0] rd_in,
    input [2:0] func3_in,
    input [6:0] func7_in,
    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input mem_read_in,
    input mem_write_in,
    input [1:0] mem_to_reg_in,
    input reg_write_in,
    input branch_in,
    input jump_in,

    output reg [31:0] rdata1_out,
    output reg [31:0] rdata2_out,
    output reg [31:0] immediate_out,
    output reg [31:0] pc_current_out,
    output reg alu_src_out,
    output reg alu_src_a_out,
    output reg [4:0] rd_out,
    output reg [2:0] func3_out,
    output reg [6:0] func7_out,
    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg [1:0] mem_to_reg_out,
    output reg reg_write_out,
    output reg branch_out,
    output reg jump_out
);

    always @(posedge clk) begin
        if (reset == 1) begin
            rdata1_out <= 0;
            rdata2_out <= 0;
            immediate_out <= 0;
            pc_current_out <= 0;
            alu_src_out <= 0;
            alu_src_a_out <= 0;
            rd_out <= 0;
            func3_out <= 0;
            func7_out <= 0;
            rs1_out <= 0;
            rs2_out <= 0;
            mem_read_out <= 0;
            mem_write_out <= 0;
            mem_to_reg_out <= 0;
            reg_write_out <= 0;
            branch_out <= 0;
            jump_out <= 0;
        end else begin
            rdata1_out <= rdata1_in;
            rdata2_out <= rdata2_in;
            immediate_out <= immediate_in;
            pc_current_out <= pc_current_in;
            alu_src_out <= alu_src_in;
            alu_src_a_out <= alu_src_a_in;
            rd_out <= rd_in;
            func3_out <= func3_in;
            func7_out <= func7_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            reg_write_out <= reg_write_in;
            branch_out <= branch_in;
            jump_out <= jump_in;
        end
    end
endmodule