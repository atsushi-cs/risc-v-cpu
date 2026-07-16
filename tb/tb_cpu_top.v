module tb_cpu_top;

    reg clk;
    reg reset;

    cpu_top dut (.clk(clk), .reset(reset));

    // Hand-assembled test program, loaded directly into dut.IMEM.mem below.
    // Addresses are byte offsets; each instruction is 4 bytes.
    //   0x00: addi x1,  x0, 5        x1 = 5
    //   0x04: addi x2,  x0, 10       x2 = 10
    //   0x08: add  x3,  x1, x2       x3 = 15
    //   0x0c: sw   x3,  0(x0)        mem[0] = 15
    //   0x10: lw   x4,  0(x0)        x4 = 15
    //   0x14: beq  x1,  x2, 8        not taken (5 != 10), falls through
    //   0x18: addi x5,  x0, 111      x5 = 111
    //   0x1c: beq  x1,  x1, 8        taken, skips 0x20
    //   0x20: addi x6,  x0, 999      SKIPPED
    //   0x24: jal  x7,  8            x7 = 0x28, skips 0x28
    //   0x28: addi x8,  x0, 888      SKIPPED
    //   0x2c: lui  x9,  0x12345      x9 = 0x12345000
    //   0x30: auipc x10, 1           x10 = 0x30 + 0x1000 = 0x1030
    //   0x34: addi x11, x0, 0x40     x11 = 0x40
    //   0x38: jalr x12, 0(x11)       x12 = 0x3c, jumps to 0x40
    //   0x3c: addi x13, x0, 777      SKIPPED
    //   0x40: jal  x0,  0            halt: self loop
    localparam integer NWORDS = 17;
    reg [31:0] program [0:NWORDS-1];
    integer i;

    initial begin
        program[0]  = 32'h00500093;
        program[1]  = 32'h00a00113;
        program[2]  = 32'h002081b3;
        program[3]  = 32'h00302023;
        program[4]  = 32'h00002203;
        program[5]  = 32'h00208463;
        program[6]  = 32'h06f00293;
        program[7]  = 32'h00108463;
        program[8]  = 32'h3e700313;
        program[9]  = 32'h008003ef;
        program[10] = 32'h37800413;
        program[11] = 32'h123454b7;
        program[12] = 32'h00001517;
        program[13] = 32'h04000593;
        program[14] = 32'h00058667;
        program[15] = 32'h30900693;
        program[16] = 32'h0000006f;

        for (i = 0; i < NWORDS; i = i + 1) begin
            dut.IMEM.mem[i*4]   = program[i][7:0];
            dut.IMEM.mem[i*4+1] = program[i][15:8];
            dut.IMEM.mem[i*4+2] = program[i][23:16];
            dut.IMEM.mem[i*4+3] = program[i][31:24];
        end
    end

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1;
        @(negedge clk);
        reset = 0;

        // 14 instructions execute before the CPU settles into the halt
        // loop at 0x40; run extra cycles as margin.
        repeat (25) @(posedge clk);
        #1;

        $display("pc_current=%h", dut.pc_current);
        if (dut.pc_current == 32'h40) begin
            $display("Pass! landed in halt loop at 0x40");
        end else begin
            $display("Fail :( expected pc=0x40, got pc=%h", dut.pc_current);
        end

        $display("x1=%0d", dut.REGFILE.registers[1]);
        if (dut.REGFILE.registers[1] == 32'd5) begin
            $display("Pass! x1 (addi)");
        end else begin
            $display("Fail :( x1 (addi)");
        end

        $display("x2=%0d", dut.REGFILE.registers[2]);
        if (dut.REGFILE.registers[2] == 32'd10) begin
            $display("Pass! x2 (addi)");
        end else begin
            $display("Fail :( x2 (addi)");
        end

        $display("x3=%0d", dut.REGFILE.registers[3]);
        if (dut.REGFILE.registers[3] == 32'd15) begin
            $display("Pass! x3 (add)");
        end else begin
            $display("Fail :( x3 (add)");
        end

        $display("x4=%0d", dut.REGFILE.registers[4]);
        if (dut.REGFILE.registers[4] == 32'd15) begin
            $display("Pass! x4 (lw)");
        end else begin
            $display("Fail :( x4 (lw)");
        end

        $display("x5=%0d", dut.REGFILE.registers[5]);
        if (dut.REGFILE.registers[5] == 32'd111) begin
            $display("Pass! x5 (branch not-taken fallthrough)");
        end else begin
            $display("Fail :( x5 (branch not-taken fallthrough)");
        end

        $display("x6=%0d", dut.REGFILE.registers[6]);
        if (dut.REGFILE.registers[6] == 32'd0) begin
            $display("Pass! x6 (skipped by taken branch)");
        end else begin
            $display("Fail :( x6 (skipped by taken branch)");
        end

        $display("x7=%h", dut.REGFILE.registers[7]);
        if (dut.REGFILE.registers[7] == 32'h28) begin
            $display("Pass! x7 (jal return address)");
        end else begin
            $display("Fail :( x7 (jal return address)");
        end

        $display("x8=%0d", dut.REGFILE.registers[8]);
        if (dut.REGFILE.registers[8] == 32'd0) begin
            $display("Pass! x8 (skipped by jal)");
        end else begin
            $display("Fail :( x8 (skipped by jal)");
        end

        $display("x9=%h", dut.REGFILE.registers[9]);
        if (dut.REGFILE.registers[9] == 32'h12345000) begin
            $display("Pass! x9 (lui)");
        end else begin
            $display("Fail :( x9 (lui)");
        end

        $display("x10=%h", dut.REGFILE.registers[10]);
        if (dut.REGFILE.registers[10] == 32'h1030) begin
            $display("Pass! x10 (auipc)");
        end else begin
            $display("Fail :( x10 (auipc)");
        end

        $display("x11=%h", dut.REGFILE.registers[11]);
        if (dut.REGFILE.registers[11] == 32'h40) begin
            $display("Pass! x11 (addi)");
        end else begin
            $display("Fail :( x11 (addi)");
        end

        $display("x12=%h", dut.REGFILE.registers[12]);
        if (dut.REGFILE.registers[12] == 32'h3c) begin
            $display("Pass! x12 (jalr return address)");
        end else begin
            $display("Fail :( x12 (jalr return address)");
        end

        $display("x13=%0d", dut.REGFILE.registers[13]);
        if (dut.REGFILE.registers[13] == 32'd0) begin
            $display("Pass! x13 (skipped by jalr)");
        end else begin
            $display("Fail :( x13 (skipped by jalr)");
        end

        $display("dmem[0]=%0d", {dut.DMEM.mem[3], dut.DMEM.mem[2], dut.DMEM.mem[1], dut.DMEM.mem[0]});
        if ({dut.DMEM.mem[3], dut.DMEM.mem[2], dut.DMEM.mem[1], dut.DMEM.mem[0]} == 32'd15) begin
            $display("Pass! dmem[0] (sw)");
        end else begin
            $display("Fail :( dmem[0] (sw)");
        end

        $finish;
    end

endmodule
