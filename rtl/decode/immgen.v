module immgen(input [31:0] instruction,
output reg [31:0] immediate
);

wire [6:0] opcode;
wire [2:0] func3;

assign opcode = instruction[6:0];
assign func3 = instruction[14:12];
reg [11:0] imm_bits;
reg [6:0] upper_imm;

always @(*) begin
    case (opcode)
        7'b0010011: begin
            imm_bits = instruction[31:20];
            case (func3)
                3'b001, 3'b101:
                    immediate = {27'b0, imm_bits[4:0]};
                default: immediate = {{20{imm_bits[11]}}, imm_bits};
            endcase
        end

        7'b0000011, 7'b1100111: begin // loads, jalr: plain I-type immediate
            imm_bits = instruction[31:20];
            immediate = {{20{imm_bits[11]}}, imm_bits};
        end

        7'b0100011: begin
            upper_imm = instruction [31:25];
            imm_bits = {upper_imm, instruction[11:7]};
            immediate = {{20{imm_bits[11]}}, imm_bits};
        end

        7'b1100011: begin
            imm_bits = {instruction[31], instruction[7], instruction[30:25], instruction [11:8]};
            immediate = {{19{imm_bits[11]}}, imm_bits, 1'b0};
        end

        7'b0110111, 7'b0010111: begin
            imm_bits = 12'b0;
            immediate = {instruction[31:12], {12{1'b0}}};
        end

        7'b1101111: begin
            imm_bits = 12'b0;
            immediate = {{11{instruction[31]}}, instruction[31],instruction[19:12], instruction[20],instruction[30:21], 1'b0};
        end

        default: immediate = 32'b0;
    endcase
end
endmodule
