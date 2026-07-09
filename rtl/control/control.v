module control (input [6:0] opcode,
    output reg reg_write,
    output reg alu_src,
    output reg alu_src_a, // 0 = rs1, 1 = PC (needed for AUIPC)
    output reg mem_read,
    output reg mem_write,
    output reg [1:0] mem_to_reg, // 00 = ALU result, 01 = mem data, 10 = PC+4, 11 = immediate
    output reg branch,
    output reg jump
    );

    always @(*) begin
    case (opcode)
        7'b0110011: begin
            reg_write = 1;
            alu_src = 0;
            alu_src_a = 0;
            mem_read = 0;
            mem_write = 0;
            mem_to_reg = 2'b00;
            branch = 0;
            jump = 0;
        end

        7'b0010011: begin
            reg_write = 1;
            alu_src = 1;
            alu_src_a = 0;
            mem_read = 0;
            mem_write = 0;
            mem_to_reg = 2'b00;
            branch = 0;
            jump = 0;
        end

        7'b0000011: begin
            reg_write = 1;
            alu_src = 1;
            alu_src_a = 0;
            mem_read = 1;
            mem_write = 0;
            mem_to_reg = 2'b01;
            branch = 0;
            jump = 0;
        end

        7'b0100011: begin
            reg_write = 0;
            alu_src = 1;
            alu_src_a = 0;
            mem_read = 0;
            mem_write = 1;
            mem_to_reg = 2'b00;
            branch = 0;
            jump = 0;
        end

        7'b1100011: begin
            reg_write = 0;
            alu_src = 0;
            alu_src_a = 0;
            mem_read = 0;
            mem_write = 0;
            mem_to_reg = 0;
            branch = 1;
            jump = 0;
        end

        7'b0110111: begin // LUI: rd = imm, bypass the ALU entirely
            reg_write = 1;
            alu_src = 0;
            alu_src_a = 0;
            mem_read = 0;
            mem_write = 0;
            mem_to_reg = 2'b11;
            branch = 0;
            jump = 0;
        end

        7'b0010111: begin // AUIPC: rd = PC + imm
            reg_write = 1;
            alu_src = 1;
            alu_src_a = 1;
            mem_read = 0;
            mem_write = 0;
            mem_to_reg = 2'b00;
            branch = 0;
            jump = 0;
        end

        7'b1101111: begin
            reg_write = 1;
            alu_src = 0;
            alu_src_a = 0;
            mem_read = 0;
            mem_write = 0;
            mem_to_reg = 2'b10;
            branch = 0;
            jump = 1;
        end

        7'b1100111: begin
            reg_write = 1;
            alu_src = 1;
            alu_src_a = 0;
            mem_read = 0;
            mem_write = 0;
            mem_to_reg = 2'b10;
            branch = 0;
            jump = 1;
        end

        default: begin
            reg_write = 0;
            alu_src = 0;
            alu_src_a = 0;
            mem_read = 0;
            mem_write = 0;
            mem_to_reg = 0;
            branch = 0;
            jump = 0;
        end
    endcase
end

endmodule