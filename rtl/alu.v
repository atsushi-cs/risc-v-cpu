module alu (input [31:0] a, 
input [31:0] b, 
input [5:0] operation, 
output [31:0] result, 
output zero);

always @(*) begin
    case (operation)
        6'b000000:
            result = a + b;
        6'b000001:
            result = a - b;
        6'b000010:
            result = a & b;
        6'b000011:
            result = a | b;
        6'b000100:
            result = a ^ b;
        6'b000101:
            result = a << b;
        6'b000110:
            result = a >> b;
        6'b000111:
            if ($signed(a) < $signed(b)) begin
                result = 1;
            end 
            else begin 
                result = 0;
            end
        6'b001000:
            if (a < b) begin
                result = 1;
            end
            else begin
                result = 0;
            end
    endcase
end

endmodule