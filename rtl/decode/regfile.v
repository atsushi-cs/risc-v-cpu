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

always @(posedge clk) begin
    
end
endmodule