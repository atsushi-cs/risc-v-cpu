module cpu_top (input clk, input reset);
    // Fetch
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] instruction;

    // Decode: instruction fields
    wire [6:0]  opcode;
    wire [4:0]  rd;
    wire [2:0]  funct3;
    wire [4:0]  rs1;
    wire [4:0]  rs2;
    wire [6:0]  funct7;

    // Control signals
    wire [1:0]  WBSel;
    wire        ImmSel;
    wire        Asel;
    wire        Br;
    wire        Jump;
    wire        regWEn;
    wire        mem_read;
    wire        mem_write;

    // Register file / immediate / writeback
    wire [31:0] rdata1;
    wire [31:0] rdata2;
    wire [31:0] immediate;
    wire [31:0] wdata;

    // Branch unit
    wire        branch_taken;

    // ALU
    wire [31:0] Asel_out;
    wire [31:0] Bsel_out;
    wire [31:0] alu_result;
    wire        alu_zero;

    // Data memory
    wire [31:0] mem_rdata;

    // Next-PC computation (branch/jump targets)
    wire [31:0] pc_plus_imm;
    wire [31:0] jalr_sum;
    wire [31:0] jalr_target;

    assign pc_plus_imm = pc_current + immediate;
    assign jalr_sum    = rdata1 + immediate;
    assign jalr_target = {jalr_sum[31:1], 1'b0}; // clear LSB per spec

    assign pc_next = (branch_taken || Jump)
                        ? ((opcode == 7'b1100111) ? jalr_target : pc_plus_imm)
                        : pc_current + 32'd4;

    pc_reg PC_REG (.clk(clk), .reset(reset), .pc_next(pc_next), .pc_current(pc_current));
    imem IMEM (.address(pc_current), .instruction(instruction));

    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign funct7 = instruction[31:25];

    control ctrl(.opcode(opcode), .alu_src(ImmSel), .alu_src_a(Asel), .branch(Br),
    .jump(Jump), .mem_read(mem_read),
    .mem_to_reg(WBSel),
    .mem_write(mem_write),
    .reg_write(regWEn));

    regfile REGFILE(.rs1(rs1), .rs2(rs2), .rd(rd), .clk(clk), .wdata(wdata), .regWEn(regWEn), .rdata1(rdata1), .rdata2(rdata2));
    immgen IMMGEN(.instruction(instruction), .immediate(immediate));
    branch_unit COMP(.rs1_data(rdata1), .rs2_data(rdata2), .func3(funct3), .branch(Br), .branch_taken(branch_taken));

    assign Asel_out = Asel ? pc_current : rdata1;
    assign Bsel_out = ImmSel ? immediate : rdata2;

    alu_top ALU(.a(Asel_out), .b(Bsel_out), .func3(funct3), .func7(funct7), .opcode(opcode), .result(alu_result), .zero(alu_zero));

    dmem DMEM(.clk(clk), .address(alu_result), .write_data(rdata2), .mem_read(mem_read), .mem_write(mem_write), .read_data(mem_rdata));

    assign wdata = (WBSel == 2'b01) ? mem_rdata :          // load
                   (WBSel == 2'b10) ? pc_current + 32'd4 : // jal/jalr return address
                   (WBSel == 2'b11) ? immediate :          // lui
                   alu_result;                             // default: alu result

endmodule

