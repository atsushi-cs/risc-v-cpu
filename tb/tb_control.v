module tb_control;
    reg [6:0] opcode;
    wire reg_write;
    wire alu_src;
    wire alu_src_a;
    wire mem_read;
    wire mem_write;
    wire [1:0] mem_to_reg;
    wire branch;
    wire jump;

    control dut (
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_src_a(alu_src_a),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump)
    );

    task check;
        input [6:0] exp_opcode;
        input exp_reg_write;
        input exp_alu_src;
        input exp_alu_src_a;
        input exp_mem_read;
        input exp_mem_write;
        input [1:0] exp_mem_to_reg;
        input exp_branch;
        input exp_jump;
        begin
            if (reg_write === exp_reg_write &&
                alu_src === exp_alu_src &&
                alu_src_a === exp_alu_src_a &&
                mem_read === exp_mem_read &&
                mem_write === exp_mem_write &&
                mem_to_reg === exp_mem_to_reg &&
                branch === exp_branch &&
                jump === exp_jump) begin
                $display("Pass! opcode=%b", exp_opcode);
            end else begin
                $display("Fail :( opcode=%b", exp_opcode);
                $display("  got : reg_write=%b alu_src=%b alu_src_a=%b mem_read=%b mem_write=%b mem_to_reg=%b branch=%b jump=%b",
                          reg_write, alu_src, alu_src_a, mem_read, mem_write, mem_to_reg, branch, jump);
                $display("  exp : reg_write=%b alu_src=%b alu_src_a=%b mem_read=%b mem_write=%b mem_to_reg=%b branch=%b jump=%b",
                          exp_reg_write, exp_alu_src, exp_alu_src_a, exp_mem_read, exp_mem_write, exp_mem_to_reg, exp_branch, exp_jump);
            end
        end
    endtask

    initial begin
        // R-type (add, sub, and, or, xor, sll, srl, sra, slt, sltu)
        opcode = 7'b0110011;
        #10 check(opcode, 1, 0, 0, 0, 0, 2'b00, 0, 0);

        // I-type ALU (addi, slti, sltiu, xori, ori, andi, slli, srli, srai)
        opcode = 7'b0010011;
        #10 check(opcode, 1, 1, 0, 0, 0, 2'b00, 0, 0);

        // Load (lb, lh, lw, lbu, lhu)
        opcode = 7'b0000011;
        #10 check(opcode, 1, 1, 0, 1, 0, 2'b01, 0, 0);

        // Store (sb, sh, sw)
        opcode = 7'b0100011;
        #10 check(opcode, 0, 1, 0, 0, 1, 2'b00, 0, 0);

        // Branch (beq, bne, blt, bge, bltu, bgeu)
        opcode = 7'b1100011;
        #10 check(opcode, 0, 0, 0, 0, 0, 2'b00, 1, 0);

        // LUI: rd = imm, bypasses the ALU (alu_src is don't-care here)
        opcode = 7'b0110111;
        #10 check(opcode, 1, 0, 0, 0, 0, 2'b11, 0, 0);

        // AUIPC: rd = PC + imm, PC routed into ALU operand A
        opcode = 7'b0010111;
        #10 check(opcode, 1, 1, 1, 0, 0, 2'b00, 0, 0);

        // JAL: rd = PC + 4, target computed separately from the main ALU
        opcode = 7'b1101111;
        #10 check(opcode, 1, 0, 0, 0, 0, 2'b10, 0, 1);

        // JALR: rd = PC + 4, target = rs1 + imm
        opcode = 7'b1100111;
        #10 check(opcode, 1, 1, 0, 0, 0, 2'b10, 0, 1);

        // Unrecognized opcode should default to all-disabled/safe outputs
        opcode = 7'b1111111;
        #10 check(opcode, 0, 0, 0, 0, 0, 2'b00, 0, 0);

        $finish;
    end
endmodule
