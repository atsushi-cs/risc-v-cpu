module alu_ctrl(input [6:0] opcode, input [2:0] func3, input [6:0] func7, output operation);
always @(*) begin
    case (opcode)
        7'b0110011: 
            case(func3)
                3'b000:
                    case (func7)
                        7'b0000000: 
                            operation = ADD
                        7'b0100000: 
                            operation = SUB
                    endcase
                3'b111:
                    operation = AND
                3'b110:
                    operation = OR
                3'b100:
                    operation = XOR
                3'b001:
                    operation = SLL
                3'b101:
                    case (func7)
                        7'b0100000:
                            operation = SRA
                        7'b0000000:
                            operation = SRL
                    endcase
                3'b010:
                    operation = SLT
                3'b011:
                    operation = SLTU
            endcase
        7'b0010011:
    endcase
end
endmodule