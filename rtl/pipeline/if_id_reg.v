module if_id_reg (
    input clk,
    input reset,
    input stall,
    input flush,
    input [31:0] pc_current_in,
    input [31:0] instruction_in,
    output reg [31:0] pc_current_out,
    output reg [31:0] instruction_out
);

    always @(posedge clk) begin
        if (reset == 1 || flush == 1) begin
            pc_current_out <= 0;
            instruction_out <= 0;
        end
        else if (stall) begin
            pc_current_out <= pc_current_out;
            instruction_out <= instruction_out;
        end
        else begin
            pc_current_out <= pc_current_in;
            instruction_out <= instruction_in;
        end
    end
endmodule