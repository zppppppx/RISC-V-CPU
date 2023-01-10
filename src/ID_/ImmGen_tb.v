module ImmGen_tb;

reg [31:0] inst;
wire[31:0] offset, Imm_id;
reg[6:0] op;
parameter DELY=100;

ImmGen Imm_inst(.inst(inst), .offset(offset), .Imm_id(Imm_id));
initial begin
		inst=32'h3e813083;	op=inst[6:0];		//3'h000003e8
#DELY	inst=32'h3e113423;	op=inst[6:0];		//3'h000003e8
#DELY	inst=32'h7d00006f;	op=inst[6:0];		//3'h000007d0
#DELY	inst=32'h7cb51863;	op=inst[6:0];		//3'h000007d0
#DELY	$stop;
end
endmodule