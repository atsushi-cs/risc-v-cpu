module tb_immgen;
    reg [31:0] instruction;
    wire [31:0] immediate;

    immgen dut2 (.instruction(instruction), .immediate(immediate));

    initial begin
        instruction = 32'h00510093;
        #10
        if (immediate == 32'd5) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        instruction = 32'hFFF10093;
        #10
        if (immediate == 32'hFFFFFFFF) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        instruction = 32'h80010093;
        #10
        if (immediate == 32'hFFFFF800) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        instruction = 32'h00212423;
        #10
        if (immediate == 32'd8) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        instruction = 32'h00208663;
        #10
        if (immediate == 32'd12) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        instruction = 32'hFE208CE3;
        #10
        if (immediate == 32'hFFFFFFF8) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        instruction = 32'h123450B7;
        #10
        if (immediate == 32'h12345000) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        instruction = 32'h010000EF;
        #10
        if (immediate ==  32'd16) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        instruction = 32'hFFDFF0EF;
        #10
        if (immediate == 32'hFFFFFFFC) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end


        $finish;
    end
endmodule
