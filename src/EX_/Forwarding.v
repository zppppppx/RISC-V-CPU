//******************************************************************************
// RISC-V verilog model
//
// Forawarding.v
//******************************************************************************

module Forawarding(RegWrite_wb, rdAddr_wb, rdAddr_mem, rs1Addr_ex, RegWrite_mem,
					rs2Addr_ex, ForwardA, ForwardB);
	input RegWrite_wb, RegWrite_mem;
	input[3:0] rdAddr_mem, rdAddr_wb, rs1Addr_ex, rs2Addr_ex;
	output reg [1:0] ForwardA, ForwardB;
	
	always@(*)
	begin
		ForwardA[0] = RegWrite_wb&&(rdAddr_wb != 4'b0)&&
						(rdAddr_mem != rs1Addr_ex)&&
						(rdAddr_wb == rs1Addr_ex);
		ForwardA[1] = RegWrite_mem&&(rdAddr_mem!=0)&&
						(rdAddr_mem == rs1Addr_ex);
		ForwardB[0] = RegWrite_wb&&(rdAddr_wb != 4'b0)&&
						(rdAddr_mem != rs2Addr_ex)&&
						(rdAddr_wb == rs2Addr_ex);
		ForwardB[1] = RegWrite_mem&&(rdAddr_mem!=0)&&
						(rdAddr_mem == rs2Addr_ex);
	end
endmodule