module regfile (
    input clk,
    input [4:0] rd,
    input [4:0] rs1,
    input [4:0] rs2,
    input [31:0] wdata,
    input regWEn,
    output [31:0] rdata1,
    output [31:0] rdata2
);

reg [31:0] registers [0:31];

integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        registers[i] = 32'b0;
    end
end

assign rdata1 = registers[rs1];
assign rdata2 = registers[rs2];

always @(posedge clk) begin
    if (regWEn && rd != 0) begin
        registers[rd] <= wdata;
    end    
end
endmodule
