module MEM_WB(clk, WB_mem, WB_wb, MemDout_mem, MemDout_wb, ALUResult_mem, 
            ALUResult_wb, rdAddr_mem, rdAddr_wb);
    
    input clk;
    input[1:0] WB_mem;
    input[31:0] MemDout_mem;
    input[31:0] ALUResult_mem;
    input[4:0] rdAddr_mem;

    output reg[1:0] WB_wb;
    output reg[31:0] MemDout_wb;
    output reg[31:0] ALUResult_wb;
    output reg[4:0] rdAddr_wb;

    always@(posedge clk) begin
        WB_wb<=WB_mem;
        MemDout_wb<=MemDout_mem;
        ALUResult_wb<=ALUResult_mem;
        rdAddr_wb<=rdAddr_mem;
    end
endmodule