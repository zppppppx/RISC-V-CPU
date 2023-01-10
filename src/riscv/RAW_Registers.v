//******************************************************************************
// RISC-V verilog model
//
// RAW_Registers.v
//******************************************************************************

module RAW_Registers(clk, rs1Addr, rs2Addr, WriteAddr, RegWrite, WriteData,
					rs1Data, rs2Data);
	input [31:0] WriteData;
	input [4:0] rs1Addr, rs2Addr, WriteAddr;
	input RegWrite, clk;
	output [31:0] rs1Data, rs2Data;
	
	wire rs1Sel, rs2Sel;
	wire [31:0] ReadData1, ReadData2;
	
	RBW_Registers RBW1(.WriteData(WriteData), .ReadRegister1(rs1Addr), .ReadRegister2(rs2Addr),
						.WriteRegister(WriteAddr), .RegWrite(RegWrite), .ReadData1(ReadData1), 
						.ReadData2(ReadData2), .clk(clk));///////////check
						
	assign rs1Sel = RegWrite && (WriteAddr != 0) && (WriteAddr == rs1Addr);
	assign rs2Sel = RegWrite && (WriteAddr != 0) && (WriteAddr == rs2Addr);
	
	assign rs1Data = (rs1Sel == 1'b0)?ReadData1:WriteData;
	assign rs2Data = (rs2Sel == 1'b0)?ReadData2:WriteData;
	
endmodule