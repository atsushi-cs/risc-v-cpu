module dmem (input clk, 
    input [31:0] address,
    input [31:0] write_data,
    input mem_write,
    input mem_read,
    output [31:0] read_data
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

    assign read_data = mem_read ? {mem[address+3], mem[address+2], mem[address+1], mem[address]} : 32'b0;

    always @(posedge clk) begin
        if (mem_write == 1) begin
            mem[address] <= write_data[7:0];
            mem[address + 1] <= write_data[15:8];
            mem[address + 2] <= write_data[23:16];
            mem[address + 3] <= write_data[31:24];
        end
    end

endmodule