`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: zju
// Engineer: qmj
//////////////////////////////////////////////////////////////////////////////////
module EX(ALUCode_ex, ALUSrcA_ex, ALUSrcB_ex,Imm_ex, rs1Addr_ex, rs2Addr_ex, rs1Data_ex, 
          rs2Data_ex, PC_ex, RegWriteData_wb, ALUResult_mem,rdAddr_mem, rdAddr_wb, 
		  RegWrite_mem, RegWrite_wb, ALUResult_ex, MemWriteData_ex, ALU_A, ALU_B);
    input [3:0] ALUCode_ex;
    input ALUSrcA_ex;
    input [1:0]ALUSrcB_ex;
    input [31:0] Imm_ex;
    input [4:0]  rs1Addr_ex;
    input [4:0]  rs2Addr_ex;
    input [31:0] rs1Data_ex;
    input [31:0] rs2Data_ex;
	input [31:0] PC_ex;
    input [31:0] RegWriteData_wb;
    input [31:0] ALUResult_mem;
	input [4:0] rdAddr_mem;
    input [4:0] rdAddr_wb;
    input RegWrite_mem;
    input RegWrite_wb;
    output [31:0] ALUResult_ex;
    output [31:0] MemWriteData_ex;
    output [31:0] ALU_A;
    output [31:0] ALU_B;

    //ALU
    wire[31:0] ALU_A, ALU_B;
    ALU ALU_inst(.ALUResult(ALUResult_ex), .ALUCode(ALUCode_ex), .A(ALU_A), .B(ALU_B));

    //Forwarding
    wire [1:0] ForwardA, ForwardB;
    Forwarding Forwarding_inst(.RegWrite_wb(RegWrite_wb), .rdAddr_wb(rdAddr_wb), .rdAddr_mem(rdAddr_mem), 
                    .rs1Addr_ex(rs1Addr_ex), .RegWrite_mem(RegWrite_mem), .rs2Addr_ex(rs2Addr_ex), 
                    .ForwardA(ForwardA), .ForwardB(ForwardB));

    //MUXA/B, select the input for ALU_A/B(forwarded)
    wire [31:0] A, B;
    MUX MUXA(.in0(rs1Data_ex), .in1(RegWriteData_wb), .in2(ALUResult_mem), .in3(), .out(A), .addr(ForwardA));
    MUX MUXB(.in0(rs2Data_ex), .in1(RegWriteData_wb), .in2(ALUResult_mem), .in3(), .out(B), .addr(ForwardB));
    assign MemWriteData_ex=B;

    //define ALU input
    assign ALU_A=(ALUSrcA_ex)?PC_ex:A;
    MUX MUX_alub(.in0(B), .in1(Imm_ex), .in2(32'd4), .in3(), .out(ALU_B), .addr(ALUSrcB_ex));
endmodule
