module tb_alu;
    reg [31:0] tb_a;
    reg [31:0] tb_b;
    reg [6:0] opcode;
    reg [2:0] func3;
    reg [6:0] func7;
    wire [31:0] tb_out;
    wire tb_zero;

    alu_top dut (.a(tb_a), .b(tb_b), .func3(func3), .func7(func7), .opcode(opcode), .result(tb_out), .zero(tb_zero));

    initial begin
        tb_a = 32'hFFFFFFFF; tb_b = 32'h00000001; func7 = 7'b0000000; func3 = 3'b000; opcode = 7'b0110011;
        #10;

        if (tb_out === 0) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        tb_a = 33; tb_b = 22; func7 = 7'b0000000; func3 = 3'b000; opcode = 7'b0110011;
        #10;

        if (tb_out === 55) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        tb_a = 3; tb_b = 3; func7 = 7'b0100000; func3 = 3'b000; opcode = 7'b0110011;
        #10;

        if (tb_out === 0) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end


        tb_a = -3; tb_b = 4; opcode = 7'b0110011; func3 = 3'b010; func7 = 7'b0000000;
        #10;

        if (tb_out === 1) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        tb_a = -3; tb_b = 4; opcode = 7'b0110011; func3 = 3'b011; func7 = 7'b0000000;
        #10;

        if (tb_out === 0) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        tb_a = 32'b1000; tb_b = 32'b0010; opcode = 7'b0110011; func3 = 3'b101; func7 = 7'b0000000;
        #10;

        if (tb_out === 32'b0010) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        tb_a = 32'hF0001000; tb_b = 4; opcode = 7'b0110011; func3 = 3'b101; func7 = 7'b0100000;
        #10;

        if (tb_out === 32'hFF000100) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

    $finish;
    end
endmodule
