module alu (input [31:0] a, 
input [31:0] b, 
input [5:0] operation, 
output reg [31:0] result, 
output zero);

always @(*) begin
    case (operation)
        6'b000000:
            result = a + b; //add
        6'b000001:
            result = a - b; //sub
        6'b000010:
            result = a & b; //and
        6'b000011:
            result = a | b; //or
        6'b000100:
            result = a ^ b; //xor
        6'b000101:
            result = a << b; //sll
        6'b000110:
            result = a >> b; //srl
        6'b000111:
            result = $signed(a) >>> b; //sra
        6'b001000: //slt
            if ($signed(a) < $signed(b)) begin
                result = 1;
            end 
            else begin 
                result = 0;
            end
        6'b001001: //sltu
            if (a < b) begin
                result = 1;
            end
            else begin
                result = 0;
            end
        default: result = 32'b0; //unsupported operation
    endcase
end

endmodule