module mem_wb_reg (
    input clk,
    input reset,

    input [31:0] mem_rdata_in,
    input [31:0] alu_result_in,
    input [31:0] pc_current_in,
    input [31:0] immediate_in,
    input [4:0]  rd_in,
    input [1:0]  mem_to_reg_in,
    input        reg_write_in,

    output reg [31:0] mem_rdata_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] pc_current_out,
    output reg [31:0] immediate_out,
    output reg [4:0]  rd_out,
    output reg [1:0]  mem_to_reg_out,
    output reg        reg_write_out
);

    always @(posedge clk) begin
        if (reset == 1) begin
            mem_rdata_out <= 0;
            alu_result_out <= 0;
            pc_current_out <= 0;
            immediate_out <= 0;
            rd_out <= 0;
            mem_to_reg_out <= 0;
            reg_write_out <= 0;
        end else begin
            mem_rdata_out <= mem_rdata_in;
            alu_result_out <= alu_result_in;
            pc_current_out <= pc_current_in;
            immediate_out <= immediate_in;
            rd_out <= rd_in;
            mem_to_reg_out <= mem_to_reg_in;
            reg_write_out <= reg_write_in;
        end
    end
endmodule
