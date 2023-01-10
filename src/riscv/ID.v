`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//////////////////////////////////////////////////////////////////////////////////
module ID(clk,Instruction_id, PC_id, RegWrite_wb, rdAddr_wb, RegWriteData_wb, MemRead_ex, 
          rdAddr_ex, MemtoReg_id, RegWrite_id, MemWrite_id, MemRead_id, ALUCode_id, 
			 ALUSrcA_id, ALUSrcB_id,  Stall, Branch, Jump, IFWrite,  JumpAddr, Imm_id,
			 rs1Data_id, rs2Data_id,rs1Addr_id,rs2Addr_id,rdAddr_id);
    //inputs
    input clk;
    input [31:0] Instruction_id;
    input [31:0] PC_id;
    input RegWrite_wb;
    input [4:0] rdAddr_wb;
    input [31:0] RegWriteData_wb;
    input MemRead_ex;
    input [4:0] rdAddr_ex;
    //outputs
    output MemtoReg_id;
    output RegWrite_id;
    output MemWrite_id;
    output MemRead_id;
    output [3:0] ALUCode_id;
    output ALUSrcA_id;
    output [1:0]ALUSrcB_id;
    output Stall;
    output Branch;
    output Jump;
    output IFWrite;
    output [31:0] JumpAddr;
    output [31:0] Imm_id;
    output [31:0] rs1Data_id;
    output [31:0] rs2Data_id;
	output[4:0] rs1Addr_id,rs2Addr_id,rdAddr_id;

    assign rs1Addr_id=Instruction_id[19:15];
    assign rs2Addr_id=Instruction_id[24:20];
    assign rdAddr_id=Instruction_id[11:7];

    //RAW_Registers
    RAW_Registers RAW_inst(
                .clk(clk), .rs1Addr(rs1Addr_id), .rs2Addr(rs2Addr_id), 
                .WriteAddr(rdAddr_wb), .RegWrite(RegWrite_wb), .WriteData(RegWriteData_wb),

	            .rs1Data(rs1Data_id), .rs2Data(rs2Data_id));

    //BranchTest
    BranchTest Branch_inst(
                .rs1Data(rs1Data_id), .rs2Data(rs2Data_id), .Instruction(Instruction_id),
            
                .Branch(Branch));

    //Decode
    wire JALR;
    wire [31:0] offset;
    Decode Decode_inst(
	        .MemtoReg(MemtoReg_id), .RegWrite(RegWrite_id), .MemWrite(MemWrite_id), 
                .MemRead(MemRead_id),.ALUCode(ALUCode_id),.ALUSrcA(ALUSrcA_id),
                .ALUSrcB(ALUSrcB_id),.Jump(Jump),.JALR(JALR),.Imm(Imm_id),.offset(offset),

                .Instruction(Instruction_id));

    //JumpAddr
    wire [31:0] PC_op;
    assign PC_op=(JALR)?rs1Data_id:PC_id;
    adder_32bits adder_inst(
                .a(PC_op),.b(offset),.ci(1'b0),.s(JumpAddr),.co());

    //Hazard detector
    assign Stall=((rdAddr_ex==rs1Addr_id)||(rdAddr_ex==rs2Addr_id))&&MemRead_ex;
    assign IFWrite=~Stall;

endmodule
