module alu_ctrl(input [6:0] opcode, 
input [2:0] func3, 
input [6:0] func7, 
output [5:0] operation);
always @(*) begin
    case (opcode)
        7'b0110011: 
            case(func3)
                3'b000:
                    case (func7)
                        7'b0000000: 
                            operation = 6'b000000; //add
                        7'b0000001:
                            operation = 6'b000001; //sub
                        default: operation = 6'b111111; 
                    endcase
                3'b111:
                    operation = 6'b000010; //and
                3'b110:
                    operation = 6'b000011; //or
                3'b100:
                    operation = 6'b000100; //xor
                3'b001:
                    7'b0000000:
                        operation = 6'b000101; //sll
                3'b101:
                    case (func7)
                        7'b0100000:
                            operation = 6'b000111; //sra
                        7'b0000000:
                            operation = 6'b000110; //srl
                        default: operation = 6'b111111; 
                    endcase
                3'b010:
                    operation = 6'b001000; //slt
                3'b011:
                    7'b0000000:
                        operation = 6'b001001; //sltu
            endcase
        default: operation = 6'b111111; 
    endcase
end
endmodule