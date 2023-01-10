`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: zju
// Engineer: qmj
//////////////////////////////////////////////////////////////////////////////////
module Risc5CPU(clk, reset, JumpFlag, Instruction_id, ALU_A, 
                     ALU_B, ALUResult_ex, PC, MemDout_mem,Stall);
    input clk;
    input reset;
    output [1:0] JumpFlag;
    output [31:0] Instruction_id;
    output [31:0] ALU_A;
    output [31:0] ALU_B;
    output [31:0] ALUResult_ex;
    output [31:0] PC;
    output [31:0] MemDout_mem;
    output Stall;

    //IF
    wire Branch, Jump, IFWrite, IF_flush;
    wire [31:0] JumpAddr, Instruction_if;
    IF IF_inst(.clk(clk), .reset(reset), .Branch(Branch), .Jump(Jump), .IFWrite(IFWrite), 
                .JumpAddr(JumpAddr), .Instruction_if(Instruction_if), .PC(PC), 
                .IF_flush(IF_flush));
    assign JumpFlag={Jump, Branch};

    //IF_ID
    wire [31:0] PC_id;
    wire res=reset||IF_flush;
    IF_ID IF_ID_inst(.clk(clk), .en(IFWrite), .reset(res), .PC_id(PC_id), .PC_if(PC), 
                .Instruction_if(Instruction_if), .Instruction_id(Instruction_id));

    //ID
    wire [31:0] RegWriteData_wb, Imm_id, rs1Data_id, rs2Data_id;
    wire RegWrite_wb, MemRead_ex, MemtoReg_id, RegWrite_id, MemWrite_id, MemRead_id, ALUSrcA_id;
    wire [4:0] rdAddr_wb, rdAddr_ex, rs1Addr_id, rs2Addr_id, rdAddr_id;
    wire [3:0] ALUCode_id;
    wire [1:0] ALUSrcB_id;
    ID ID_inst(.clk(clk), .Instruction_id(Instruction_id), .PC_id(PC_id), .RegWrite_wb(RegWrite_wb), 
                .rdAddr_wb(rdAddr_wb), .RegWriteData_wb(RegWriteData_wb), .MemRead_ex(MemRead_ex), 
                .rdAddr_ex(rdAddr_ex), .MemtoReg_id(MemtoReg_id), .RegWrite_id(RegWrite_id), 
                .MemWrite_id(MemWrite_id), .MemRead_id(MemRead_id), .ALUCode_id(ALUCode_id), 
			    .ALUSrcA_id(ALUSrcA_id), .ALUSrcB_id(ALUSrcB_id),  .Stall(Stall), .Branch(Branch), 
                .Jump(Jump), .IFWrite(IFWrite),  .JumpAddr(JumpAddr), .Imm_id(Imm_id),
			    .rs1Data_id(rs1Data_id), .rs2Data_id(rs2Data_id), .rs1Addr_id(rs1Addr_id),
                .rs2Addr_id(rs2Addr_id), .rdAddr_id(rdAddr_id));

    //ID_EX
    wire [1:0] WB_ex, ALUSrcB_ex;
    wire MemWrite_ex, ALUSrcA_ex;
    wire [3:0] ALUCode_ex;
    wire [31:0] PC_ex, Imm_ex, rs1Data_ex, rs2Data_ex;
    wire [4:0] rs1Addr_ex, rs2Addr_ex;
    ID_EX ID_EX_inst(.clk(clk), .reset(Stall), .WB_id({MemtoReg_id, RegWrite_id}), .WB_ex(WB_ex), 
                .M_id({MemWrite_id, MemRead_id}), .M_ex({MemWrite_ex, MemRead_ex}), 
                .EX_id({ALUCode_id, ALUSrcA_id, ALUSrcB_id}), .EX_ex({ALUCode_ex, ALUSrcA_ex, ALUSrcB_ex}), 
                .PC_id(PC_id), .PC_ex(PC_ex), .Imm_id(Imm_id), .Imm_ex(Imm_ex), .rdAddr_id(rdAddr_id), 
                .rdAddr_ex(rdAddr_ex), .rs1Addr_id(rs1Addr_id), .rs1Addr_ex(rs1Addr_ex), 
                .rs2Addr_id(rs2Addr_id), .rs2Addr_ex(rs2Addr_ex), .rs1Data_id(rs1Data_id), 
                .rs1Data_ex(rs1Data_ex), .rs2Data_id(rs2Data_id), .rs2Data_ex(rs2Data_ex));

    //EX
    wire [31:0] ALUResult_mem, MemWriteData_ex;
    wire [4:0] rdAddr_mem;
    wire RegWrite_mem;
    EX EX_inst(.ALUCode_ex(ALUCode_ex), .ALUSrcA_ex(ALUSrcA_ex), .ALUSrcB_ex(ALUSrcB_ex), .Imm_ex(Imm_ex), 
                .rs1Addr_ex(rs1Addr_ex), .rs2Addr_ex(rs2Addr_ex), .rs1Data_ex(rs1Data_ex), 
                .rs2Data_ex(rs2Data_ex), .PC_ex(PC_ex), .RegWriteData_wb(RegWriteData_wb), 
                .ALUResult_mem(ALUResult_mem), .rdAddr_mem(rdAddr_mem), .rdAddr_wb(rdAddr_wb), 
		        .RegWrite_mem(RegWrite_mem), .RegWrite_wb(RegWrite_wb), .ALUResult_ex(ALUResult_ex), 
                .MemWriteData_ex(MemWriteData_ex), .ALU_A(ALU_A), .ALU_B(ALU_B));

    //EX_MEM
    wire [1:0] WB_mem;
    wire M_mem;
    wire [31:0] MemWriteData_mem;
    EX_MEM EX_MEM_inst(.clk(clk), .WB_ex(WB_ex), .WB_mem(WB_mem), .M_ex(MemWrite_ex), .M_mem(M_mem), 
                .ALUResult_ex(ALUResult_ex), .ALUResult_mem(ALUResult_mem), 
                .MemWriteData_ex(MemWriteData_ex), .MemWriteData_mem(MemWriteData_mem), .rdAddr_ex(rdAddr_ex), 
                .rdAddr_mem(rdAddr_mem));

    assign RegWrite_mem=WB_mem[0];

    //MEM
    DataRAM DataRAM_inst(.a(ALUResult_mem), .d(MemWriteData_mem), .clk(clk), .we(M_mem), .spo(MemDout_mem));

    //MEM_WB
    wire MemtoReg_wb;
    wire [31:0] MemDout_wb, ALUResult_wb;
    MEM_WB MEM_WB_inst(.clk(clk), .WB_mem(WB_mem), .WB_wb({MemtoReg_wb, RegWrite_wb}), 
                .MemDout_mem(MemDout_mem), .MemDout_wb(MemDout_wb), .ALUResult_mem(ALUResult_mem), 
                .ALUResult_wb(ALUResult_wb), .rdAddr_mem(rdAddr_mem), .rdAddr_wb(rdAddr_wb));

    //WB
    assign RegWriteData_wb=(MemtoReg_wb)?MemDout_wb:ALUResult_wb;

endmodule
