module alu_ctrl(input [6:0] opcode, 
    input [2:0] func3, 
    input [6:0] func7, 
    output reg [5:0] operation
);

always @(*) begin
    case (opcode)
        7'b0110011: //r-type instructions
            case (func3)
                3'b000:
                    case (func7)
                        7'b0000000: 
                            operation = 6'b000000; //add
                        7'b0100000:
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
                    operation = 6'b001001; //sltu
                default: operation = 6'b111111;
            endcase
        7'b0010011: //i-type instructions
            case (func3)
                3'b000:
                    operation = 6'b000000; //addi
                3'b111:
                    operation = 6'b000010; //andi
                3'b110:
                    operation = 6'b000011; //ori
                 3'b100:
                    operation = 6'b000100; //xori
                3'b001:
                    operation = 6'b000101; //slli
                3'b101:
                    case (func7)
                        7'b0100000:
                            operation = 6'b000111; //srai
                        7'b0000000:
                            operation = 6'b000110; //srli
                        default: operation = 6'b111111;
                    endcase
                3'b010:
                    operation = 6'b001000; //slti
                3'b011:
                    operation = 6'b001001; //sltiu
                default: operation = 6'b111111;
            endcase
        7'b0010111: //auipc: rd = PC + imm
            operation = 6'b000000; //add
        7'b0000011: //loads: address = rs1 + imm
            operation = 6'b000000; //add
        7'b0100011: //stores: address = rs1 + imm
            operation = 6'b000000; //add
        default: operation = 6'b111111;
    endcase
end
endmodule
