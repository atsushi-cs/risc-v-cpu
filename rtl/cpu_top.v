module cpu_top (input clk, input reset);

    //======================================================================
    // IF stage
    //======================================================================
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] instruction;

    pc_reg PC_REG (.clk(clk), .reset(reset), .pc_next(pc_next), .pc_current(pc_current));
    imem IMEM (.address(pc_current), .instruction(instruction));

    //======================================================================
    // IF/ID
    //======================================================================
    wire [31:0] pc_current_ID;
    wire [31:0] instruction_ID;

    if_id_reg IF_ID_REG (
        .clk(clk), .reset(reset),
        .pc_current_in(pc_current), .instruction_in(instruction),
        .pc_current_out(pc_current_ID), .instruction_out(instruction_ID)
    );

    //======================================================================
    // ID stage
    //======================================================================
    wire [6:0] opcode_ID;
    wire [4:0] rd_ID;
    wire [2:0] funct3_ID;
    wire [4:0] rs1_ID;
    wire [4:0] rs2_ID;
    wire [6:0] funct7_ID;

    assign opcode_ID = instruction_ID[6:0];
    assign rd_ID     = instruction_ID[11:7];
    assign funct3_ID = instruction_ID[14:12];
    assign rs1_ID    = instruction_ID[19:15];
    assign rs2_ID    = instruction_ID[24:20];
    assign funct7_ID = instruction_ID[31:25];

    wire [1:0] WBSel_ID;
    wire       ImmSel_ID;
    wire       Asel_ID;
    wire       Br_ID;
    wire       Jump_ID;
    wire       regWEn_ID;
    wire       mem_read_ID;
    wire       mem_write_ID;

    control ctrl (.opcode(opcode_ID), .alu_src(ImmSel_ID), .alu_src_a(Asel_ID), .branch(Br_ID),
        .jump(Jump_ID), .mem_read(mem_read_ID),
        .mem_to_reg(WBSel_ID),
        .mem_write(mem_write_ID),
        .reg_write(regWEn_ID));

    wire [31:0] rdata1_ID;
    wire [31:0] rdata2_ID;
    wire [31:0] immediate_ID;

    wire [4:0]  rd_WB;
    wire [31:0] wdata_WB;
    wire        regWEn_WB;

    regfile REGFILE (.rs1(rs1_ID), .rs2(rs2_ID), .rd(rd_WB), .clk(clk), .wdata(wdata_WB),
        .regWEn(regWEn_WB), .rdata1(rdata1_ID), .rdata2(rdata2_ID));
    immgen IMMGEN (.instruction(instruction_ID), .immediate(immediate_ID));

    //======================================================================
    // ID/EX
    //======================================================================
    wire [31:0] rdata1_EX, rdata2_EX, immediate_EX, pc_current_EX;
    wire        ImmSel_EX, Asel_EX;
    wire [4:0]  rd_EX;
    wire [2:0]  funct3_EX;
    wire [6:0]  funct7_EX;
    wire [6:0]  opcode_EX;
    wire [4:0]  rs1_EX, rs2_EX;
    wire        mem_read_EX, mem_write_EX;
    wire [1:0]  WBSel_EX;
    wire        regWEn_EX;
    wire        Br_EX, Jump_EX;

    id_ex_reg ID_EX_REG (
        .clk(clk), .reset(reset),
        .rdata1_in(rdata1_ID), .rdata2_in(rdata2_ID), .immediate_in(immediate_ID), .pc_current_in(pc_current_ID),
        .alu_src_in(ImmSel_ID), .alu_src_a_in(Asel_ID), .rd_in(rd_ID), .func3_in(funct3_ID), .func7_in(funct7_ID),
        .opcode_in(opcode_ID), .rs1_in(rs1_ID), .rs2_in(rs2_ID), .mem_read_in(mem_read_ID), .mem_write_in(mem_write_ID),
        .mem_to_reg_in(WBSel_ID), .reg_write_in(regWEn_ID), .branch_in(Br_ID), .jump_in(Jump_ID),

        .rdata1_out(rdata1_EX), .rdata2_out(rdata2_EX), .immediate_out(immediate_EX), .pc_current_out(pc_current_EX),
        .alu_src_out(ImmSel_EX), .alu_src_a_out(Asel_EX), .rd_out(rd_EX), .func3_out(funct3_EX), .func7_out(funct7_EX),
        .opcode_out(opcode_EX), .rs1_out(rs1_EX), .rs2_out(rs2_EX), .mem_read_out(mem_read_EX), .mem_write_out(mem_write_EX),
        .mem_to_reg_out(WBSel_EX), .reg_write_out(regWEn_EX), .branch_out(Br_EX), .jump_out(Jump_EX)
    );

    //======================================================================
    // EX stage
    //======================================================================
    wire [31:0] Asel_out;
    wire [31:0] Bsel_out;
    wire [31:0] alu_result;
    wire        alu_zero;
    wire        branch_taken;

    assign Asel_out = Asel_EX ? pc_current_EX : rdata1_EX;
    assign Bsel_out = ImmSel_EX ? immediate_EX : rdata2_EX;

    alu_top ALU (.a(Asel_out), .b(Bsel_out), .func3(funct3_EX), .func7(funct7_EX), .opcode(opcode_EX), .result(alu_result), .zero(alu_zero));
    branch_unit COMP (.rs1_data(rdata1_EX), .rs2_data(rdata2_EX), .func3(funct3_EX), .branch(Br_EX), .branch_taken(branch_taken));


    wire [31:0] pc_plus_imm_EX;
    wire [31:0] jalr_sum_EX;
    wire [31:0] jalr_target_EX;
    wire [31:0] branch_target_EX;
    wire        pc_src_EX;

    assign pc_plus_imm_EX   = pc_current_EX + immediate_EX;
    assign jalr_sum_EX      = rdata1_EX + immediate_EX;
    assign jalr_target_EX   = {jalr_sum_EX[31:1], 1'b0};
    assign branch_target_EX = (opcode_EX == 7'b1100111) ? jalr_target_EX : pc_plus_imm_EX;
    assign pc_src_EX        = branch_taken || Jump_EX;

    assign pc_next = pc_src_EX ? branch_target_EX : (pc_current + 32'd4);

    //======================================================================
    // EX/MEM
    //======================================================================
    wire [31:0] alu_result_MEM, rdata2_MEM, pc_current_MEM, immediate_MEM;
    wire [4:0]  rd_MEM;
    wire        mem_read_MEM, mem_write_MEM;
    wire [1:0]  WBSel_MEM;
    wire        regWEn_MEM;

    ex_mem_reg EX_MEM_REG (
        .clk(clk), .reset(reset),
        .alu_result_in(alu_result), .rdata2_in(rdata2_EX), .pc_current_in(pc_current_EX), .immediate_in(immediate_EX),
        .rd_in(rd_EX), .mem_read_in(mem_read_EX), .mem_write_in(mem_write_EX), .mem_to_reg_in(WBSel_EX), .reg_write_in(regWEn_EX),

        .alu_result_out(alu_result_MEM), .rdata2_out(rdata2_MEM), .pc_current_out(pc_current_MEM), .immediate_out(immediate_MEM),
        .rd_out(rd_MEM), .mem_read_out(mem_read_MEM), .mem_write_out(mem_write_MEM), .mem_to_reg_out(WBSel_MEM), .reg_write_out(regWEn_MEM)
    );

    //======================================================================
    // MEM stage
    //======================================================================
    wire [31:0] mem_rdata;

    dmem DMEM (.clk(clk), .address(alu_result_MEM), .write_data(rdata2_MEM), .mem_read(mem_read_MEM), .mem_write(mem_write_MEM), .read_data(mem_rdata));

    //======================================================================
    // MEM/WB
    //======================================================================
    wire [31:0] mem_rdata_WB, alu_result_WB, pc_current_WB, immediate_WB;
    wire [1:0]  WBSel_WB;

    mem_wb_reg MEM_WB_REG (
        .clk(clk), .reset(reset),
        .mem_rdata_in(mem_rdata), .alu_result_in(alu_result_MEM), .pc_current_in(pc_current_MEM), .immediate_in(immediate_MEM),
        .rd_in(rd_MEM), .mem_to_reg_in(WBSel_MEM), .reg_write_in(regWEn_MEM),

        .mem_rdata_out(mem_rdata_WB), .alu_result_out(alu_result_WB), .pc_current_out(pc_current_WB), .immediate_out(immediate_WB),
        .rd_out(rd_WB), .mem_to_reg_out(WBSel_WB), .reg_write_out(regWEn_WB)
    );

    //======================================================================
    // WB stage
    //======================================================================
    assign wdata_WB = (WBSel_WB == 2'b01) ? mem_rdata_WB :           // load
                      (WBSel_WB == 2'b10) ? pc_current_WB + 32'd4 :  // jal/jalr return address
                      (WBSel_WB == 2'b11) ? immediate_WB :           // lui
                      alu_result_WB;                                 // default: alu result

endmodule
