module tb_dmem;

    reg clk;
    reg [31:0] address;
    reg [31:0] write_data;
    reg mem_write;
    reg mem_read;
    wire [31:0] read_data;

    dmem dut (.clk(clk), .address(address), .write_data(write_data), .mem_write(mem_write), .mem_read(mem_read), .read_data(read_data));

    initial clk = 0;

    always #5 clk = ~clk;

    initial begin
        address = 0; write_data = 0; mem_write = 0; mem_read = 0;

        // write a word and read it back
        address = 0; write_data = 32'hDEADBEEF; mem_write = 1; mem_read = 0;
        @(posedge clk);
        #1;
        mem_write = 0; mem_read = 1;
        #1;
        $display("read_data=%h", read_data);
        if (read_data == 32'hDEADBEEF) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        // write at a non-zero address and check byte ordering
        address = 8; write_data = 32'h11223344; mem_write = 1; mem_read = 0;
        @(posedge clk);
        #1;
        mem_write = 0; mem_read = 1;
        #1;
        $display("read_data=%h", read_data);
        if (read_data == 32'h11223344) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        // mem_read = 0 should output 0 regardless of memory contents
        address = 0; mem_write = 0; mem_read = 0;
        #1;
        $display("read_data=%h", read_data);
        if (read_data == 32'b0) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        // mem_write = 0 should not modify memory
        address = 0; write_data = 32'hFFFFFFFF; mem_write = 0; mem_read = 0;
        @(posedge clk);
        #1;
        mem_read = 1;
        #1;
        $display("read_data=%h", read_data);
        if (read_data == 32'hDEADBEEF) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        // writes to different addresses should not overlap
        address = 8; mem_read = 1;
        #1;
        $display("read_data=%h", read_data);
        if (read_data == 32'h11223344) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        $finish;
    end

endmodule
