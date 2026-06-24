module immgen(input [31:0] instruction,
output reg [31:0] immediate
);

wire [6:0] opcode;
wire [2:0] func3;
wire [11:0] imm_bits;

assign opcode = instruction[6:0];
assign func3 = instruction[14:12];
assign imm_bits = instruction[31:20];

always @(*) begin
    case (opcode)
        7'b0010011:
            case (func3)
                3'b001:
                    immediate = {27'b0, imm_bits[4:0]};
                3'b101:
                    immediate = {27'b0, imm_bits[4:0]};
                default: immediate = {{20{imm_bits[11]}}, imm_bits};
            endcase
        default: immediate = 32'b0;
    endcase
end
endmodule