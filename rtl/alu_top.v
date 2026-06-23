module alu_top(
    input [31:0] a, 
    input [31:0] b, 
    input [2:0] func3, 
    input [6:0] func7, 
    input [6:0] opcode, 
    output [31:0] result, 
    output zero
    );

wire [5:0] operation;

alu_ctrl instance1(.opcode(opcode), .func3(func3), .func7(func7), .operation(operation));

alu instance2(.a(a), .b(b), .operation(operation), .result(result), .zero(zero));

endmodule