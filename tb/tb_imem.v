module tb_imem;

    reg [31:0] address;
    wire [31:0] instruction;

    imem #(.MEM_FILE("tb/imem_test.hex")) dut (.address(address), .instruction(instruction));

    initial begin
        address = 0;
        #1;
        $display("instruction=%h", instruction);
        if (instruction == 32'h00500093) begin // addi x1, x0, 5
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        address = 4;
        #1;
        $display("instruction=%h", instruction);
        if (instruction == 32'h00a00113) begin // addi x2, x0, 10
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        address = 8;
        #1;
        $display("instruction=%h", instruction);
        if (instruction == 32'h002081b3) begin // add x3, x1, x2
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        $finish;
    end

endmodule
