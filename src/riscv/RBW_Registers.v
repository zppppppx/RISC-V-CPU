//******************************************************************************
// RISC-V verilog model
//
// RBW_Registers.v
//******************************************************************************

module RBW_Registers(WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk,
					ReadData1, ReadData2);
	input [31:0] WriteData;
	input [4:0] WriteRegister, ReadRegister1, ReadRegister2;
	input RegWrite, clk;
	output [31:0] ReadData1, ReadData2;
	
	reg [31:0] regs[31:0];
	assign ReadData1=(ReadRegister1==5'b0)?32'b0:regs[ReadRegister1];
	assign ReadData2=(ReadRegister2==5'b0)?32'b0:regs[ReadRegister2];
	always@(posedge clk) if(RegWrite) regs[WriteRegister] <= WriteData;
	
endmodule