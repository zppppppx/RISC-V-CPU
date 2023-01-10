module ImmGen(inst, offset, Imm_id);

input [31:0] inst; 													//input instructions;
output reg[31:0] offset, Imm_id;									//output offset and Imm_id;

//define parameters
	parameter	 I_type = 7'h13;
	parameter	 LW = 7'h03;
	parameter	 JALR = 7'h67;
	parameter	 SW = 7'h23;
	parameter	 LUI = 7'h37;
	parameter	 AUIPC = 7'h17;
	parameter 	 JAL = 7'h6F;
	parameter	 SB_type = 7'h63;

reg Shift;
always @(*) begin
Shift = (inst[14:12]==3'b001) || (inst[14:12]==3'b101);				//distinguish two kinds of I_type
	case(inst[6:0])
		I_type: begin Imm_id <= (Shift)?{26'd0,inst[25:20]}:{{20{inst[31]}},inst[31:20]}; 
						offset<=32'h00000000; end
		LW:		begin Imm_id <= {{20{inst[31]}},inst[31:20]}; offset <= 32'h00000000; end
		JALR:	begin Imm_id <= 32'h00000000; offset <= {{20{inst[31]}},inst[31:20]}; end
		SW: 	begin Imm_id <= {{20{inst[31]}},inst[31:25],inst[11:7]};offset <= 32'h00000000; end
		JAL:	begin Imm_id <= 32'h00000000;
						offset <= {{11{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21],1'b0}; end
		LUI:	begin Imm_id <= {inst[31:20],12'd0}; offset <= 32'h00000000; end
		AUIPC:	begin Imm_id <= {inst[31:20],12'd0}; offset <= 32'h00000000; end
		SB_type:	begin Imm_id <= 32'h00000000;
						offset <= {{19{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8],1'b0}; end
						
	endcase
end
endmodule