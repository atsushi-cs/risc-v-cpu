module pc_reg(
    input clk,
    input [31:0] pc_next,
    input reset,
    input stall,
    output reg [31:0] pc_current
);

    always @(posedge clk) begin
        if (reset == 1) begin
            pc_current <= 32'b0;
        end
        else if (stall) begin
            pc_current <= pc_current;
        end
        else begin
            pc_current <= pc_next;
        end
    end

endmodule