module imem(input [31:0] address,
    output [31:0] instruction
);
    parameter MEM_FILE = "";
    localparam SIZE = 1024;
    reg [7:0] mem [0:SIZE-1];

    integer i;
    initial begin
        for (i = 0; i < SIZE; i = i + 1) begin
            mem[i] = 8'b0;
        end
        if (MEM_FILE != "") begin
            $readmemh(MEM_FILE, mem);
        end
    end

    assign instruction = {mem[address+3], mem[address+2], mem[address+1], mem[address]};

endmodule