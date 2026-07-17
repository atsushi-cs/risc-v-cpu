module tb_forwarding_unit;
    reg [4:0] rd_exmem;
    reg reg_write_exmem;
    reg [4:0] rd_memwb;
    reg reg_write_memwb;
    reg [4:0] rs1_idex;
    reg [4:0] rs2_idex;
    wire [1:0] forward_a;
    wire [1:0] forward_b;

    forwarding_unit dut (
        .rd_exmem(rd_exmem),
        .reg_write_exmem(reg_write_exmem),
        .rd_memwb(rd_memwb),
        .reg_write_memwb(reg_write_memwb),
        .rs1_idex(rs1_idex),
        .rs2_idex(rs2_idex),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    task check;
        input [1:0] exp_forward_a;
        input [1:0] exp_forward_b;
        begin
            if (forward_a === exp_forward_a && forward_b === exp_forward_b) begin
                $display("Pass! forward_a=%b forward_b=%b", forward_a, forward_b);
            end else begin
                $display("Fail :(");
                $display("  got : forward_a=%b forward_b=%b", forward_a, forward_b);
                $display("  exp : forward_a=%b forward_b=%b", exp_forward_a, exp_forward_b);
            end
        end
    endtask

    initial begin
        rd_exmem = 5'd0;
        reg_write_exmem = 0;
        rd_memwb = 5'd0;
        reg_write_memwb = 0;
        rs1_idex = 5'd1;
        rs2_idex = 5'd2;
        #10 check(2'b00, 2'b00);

        rd_exmem = 5'd1;
        reg_write_exmem = 1;
        rd_memwb = 5'd0;
        reg_write_memwb = 0;
        rs1_idex = 5'd1;
        rs2_idex = 5'd3;
        #10 check(2'b01, 2'b00);

        rd_exmem = 5'd0;
        reg_write_exmem = 0;
        rd_memwb = 5'd2;
        reg_write_memwb = 1;
        rs1_idex = 5'd3;
        rs2_idex = 5'd2;
        #10 check(2'b00, 2'b10);

        rd_exmem = 5'd5;
        reg_write_exmem = 1;
        rd_memwb = 5'd5;
        reg_write_memwb = 1;
        rs1_idex = 5'd5;
        rs2_idex = 5'd5;
        #10 check(2'b01, 2'b01);

        rd_exmem = 5'd0;
        reg_write_exmem = 1;
        rd_memwb = 5'd0;
        reg_write_memwb = 1;
        rs1_idex = 5'd0;
        rs2_idex = 5'd0;
        #10 check(2'b00, 2'b00);

        rd_exmem = 5'd4;
        reg_write_exmem = 0;
        rd_memwb = 5'd6;
        reg_write_memwb = 0;
        rs1_idex = 5'd4;
        rs2_idex = 5'd6;
        #10 check(2'b00, 2'b00);

        rd_exmem = 5'd7;
        reg_write_exmem = 1;
        rd_memwb = 5'd9;
        reg_write_memwb = 1;
        rs1_idex = 5'd9;
        rs2_idex = 5'd7;
        #10 check(2'b10, 2'b01);

        $finish;
    end
endmodule
