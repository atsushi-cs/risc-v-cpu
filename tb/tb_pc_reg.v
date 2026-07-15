module tb_pc_reg;

    reg [31:0] pc_next;
    reg reset;
    reg clk;
    wire [31:0] pc_current;

    pc_reg dut3(.pc_next(pc_next), .reset(reset), .clk(clk), .pc_current(pc_current));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        pc_next = 0; reset = 0;

        pc_next = 5; reset = 0;

        @(posedge clk);
        @(posedge clk);
        $display("pc_current=%0d", pc_current);
        if (pc_current == pc_next) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        pc_next = 10; reset = 1;

        @(posedge clk);
        @(posedge clk);
        $display("pc_current=%0d", pc_current);
        if (pc_current == 0) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        pc_next = 15; reset = 0;

        @(posedge clk);
        @(posedge clk);

        reset = 1;

        @(posedge clk);
        @(posedge clk);
        $display("pc_current=%0d", pc_current);
        if (pc_current == 0) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        $finish;
    end

endmodule