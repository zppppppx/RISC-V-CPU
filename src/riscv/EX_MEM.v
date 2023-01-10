module EX_MEM(clk, WB_ex, WB_mem, M_ex, M_mem, ALUResult_ex, ALUResult_mem, 
            MemWriteData_ex, MemWriteData_mem, rdAddr_ex, rdAddr_mem);

    input clk;     
    input [1:0] WB_ex;
    input M_ex;
    input [31:0] ALUResult_ex, MemWriteData_ex;
    input [4:0] rdAddr_ex;

    output reg [1:0] WB_mem;
    output reg M_mem;
    output reg [31:0] ALUResult_mem, MemWriteData_mem;
    output reg [4:0] rdAddr_mem;

    always@(posedge clk) begin
        WB_mem<=WB_ex;
        M_mem<=M_ex;
        ALUResult_mem<=ALUResult_ex;
        MemWriteData_mem<=MemWriteData_ex;
        rdAddr_mem<=rdAddr_ex;
    end
endmodule