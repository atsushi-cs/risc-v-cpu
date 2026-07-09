module tb_regfile;

    reg clk;
    reg [4:0] rd;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [31:0] wdata;
    reg regWEn;
    wire [31:0] rdata1;
    wire [31:0] rdata2;

    regfile dut1 (.clk(clk), .rd(rd), .rs1(rs1),.rs2(rs2),.wdata(wdata),.regWEn(regWEn),.rdata1(rdata1), .rdata2(rdata2));

    initial clk = 0;

    always #5 clk = ~clk;

    initial begin
        regWEn = 0; rd = 0; rs1 = 0; rs2 = 0; wdata = 0;

        rd = 5; wdata = 20; regWEn = 1; rs1 = 5; rs2 = 5;

        @(posedge clk);
        @(posedge clk);
        $display("rdata1=%0d rdata2=%0d", rdata1, rdata2);
        if (rdata1 == 20 && rdata2 == 20) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end

        rd = 0; wdata = 40; regWEn = 1; rs1 = 0; rs2 = 0;
        @(posedge clk);
        @(posedge clk);
        $display("rdata1=%0d rdata2=%0d", rdata1, rdata2);
        if (rdata1 == 0 && rdata2 == 0) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end  
        
        rd = 6; wdata = 20; regWEn = 0; rs1 = 6; rs2 = 6;
        @(posedge clk);
        @(posedge clk);
        $display("rdata1=%0d rdata2=%0d", rdata1, rdata2);
        if (rdata1 == 0 && rdata2 == 0) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end  

        rd = 5; wdata = 20; regWEn = 1; rs1 = 5; rs2 = 1;
        @(posedge clk);
        @(posedge clk);
        rd = 1; wdata = 30; regWEn = 1; rs1 = 5; rs2 = 1;
        @(posedge clk);
        @(posedge clk);
        $display("rdata1=%0d rdata2=%0d", rdata1, rdata2);
        if (rdata1 == 20 && rdata2 == 30) begin
            $display("Pass!");
        end else begin
            $display("Fail :(");
        end  
               
        $finish;
    end
endmodule
