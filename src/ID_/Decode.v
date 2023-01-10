//******************************************************************************
// //
// Decode.v
//******************************************************************************

module Decode(   
	// Outputs
	MemtoReg, RegWrite, MemWrite, MemRead,ALUCode,ALUSrcA,ALUSrcB,Jump,JALR,Imm,offset,
	// Inputs
    Instruction);
	input [31:0]	Instruction;	// current instruction
	output reg		   MemtoReg;		// use memory output as data to write into register
	output reg		   RegWrite;		// enable writing back to the register
	output reg		   MemWrite;		// write to memory
	output reg        MemRead;
	output reg [3:0]   ALUCode;         // ALU operation select
	output reg     	ALUSrcA;
	output reg [1:0]   ALUSrcB;
	output reg        Jump;
	output reg        JALR;
	output reg [31:0]   Imm,offset;
	
//******************************************************************************
//  instruction type decode
//******************************************************************************
	parameter  R_type_op=   7'b0110011;
	parameter  I_type_op=   7'b0010011;
	parameter  SB_type_op=  7'b1100011;
	parameter  LW_op=       7'b0000011;
	parameter  JALR_op=     7'b1100111;
	parameter  SW_op=       7'b0100011;
	parameter  LUI_op=      7'b0110111;
	parameter  AUIPC_op=    7'b0010111;	
	parameter  JAL_op=      7'b1101111;	
//
  //
   parameter  ADD_funct3 =     3'b000 ;
   parameter  SUB_funct3 =     3'b000 ;
   parameter  SLL_funct3 =     3'b001 ;
   parameter  SLT_funct3 =     3'b010 ;
   parameter  SLTU_funct3 =    3'b011 ;
   parameter  XOR_funct3 =     3'b100 ;
   parameter  SRL_funct3 =     3'b101 ;
   parameter  SRA_funct3 =     3'b101 ;
   parameter  OR_funct3 =      3'b110 ;
   parameter  AND_funct3 =     3'b111;
   //
   parameter  ADDI_funct3 =     3'b000 ;
   parameter  SLLI_funct3 =     3'b001 ;
   parameter  SLTI_funct3 =     3'b010 ;
   parameter  SLTIU_funct3 =    3'b011 ;
   parameter  XORI_funct3 =     3'b100 ;
   parameter  SRLI_funct3 =     3'b101 ;
   parameter  SRAI_funct3 =     3'b101 ;
   parameter  ORI_funct3 =      3'b110 ;
   parameter  ANDI_funct3 =     3'b111 ;
   //
   parameter	 alu_add=  4'b0000;
   parameter	 alu_sub=  4'b0001;
   parameter	 alu_lui=  4'b0010;
   parameter	 alu_and=  4'b0011;
   parameter	 alu_xor=  4'b0100;
   parameter	 alu_or =  4'b0101;
   parameter 	 alu_sll=  4'b0110;
   parameter	 alu_srl=  4'b0111;
   parameter	 alu_sra=  4'b1000;
   parameter	 alu_slt=  4'b1001;
   parameter	 alu_sltu= 4'b1010; 

//******************************************************************************
// instruction field
//******************************************************************************
	wire [6:0]		op;
	wire  	 	    funct6_7;
	wire [2:0]		funct3;
	assign op			= Instruction[6:0];
	assign funct6_7		= Instruction[30];
 	assign funct3		= Instruction[14:12];

  reg R_type, I_type, SB_type, LW, SW, LUI, AUIPC, JAL, Shift;
always @(*) begin
// assign flags if types matched 
	
  R_type<=(op==R_type_op);
  I_type<=(op==I_type_op);
  SB_type<=(op==SB_type_op);
  LW<=(op==LW_op);
  JALR<=(op==JALR_op);
  SW<=(op==SW_op);
  LUI<=(op==LUI_op);
  AUIPC<=(op==AUIPC_op);
  JAL<=(op==JAL_op);

//assign flags for LW
  MemtoReg=LW;
  MemRead=LW;

//assign flags for SW
  MemWrite=SW;

//assign flags for writing reg
  RegWrite=R_type||I_type||LW||JALR||LUI||AUIPC||JAL;

//assign flags for Jump
  Jump=JALR||JAL;

//assign flags for selection of oprands A and B
  ALUSrcA=JALR||JAL||AUIPC;
  ALUSrcB={JAL||JALR, ~(R_type||JAL||JALR)};

//assign flags for ALUCode
  casex({funct6_7,R_type,I_type,LUI,funct3})
    {1'b0,3'o4,ADD_funct3}: ALUCode<=alu_add;
    {1'b1,3'o4,SUB_funct3}: ALUCode<=alu_sub;
    {1'b0,3'o4,SLL_funct3}: ALUCode<=alu_sll;
    {1'b0,3'o4,SLT_funct3}: ALUCode<=alu_slt;
    {1'b0,3'o4,SLTU_funct3}: ALUCode<=alu_sltu;
    {1'b0,3'o4,XOR_funct3}: ALUCode<=alu_xor;
    {1'b0,3'o4,SRL_funct3}: ALUCode<=alu_srl;
    {1'b0,3'o4,SRA_funct3}: ALUCode<=alu_sra;
    {1'b0,3'o4,OR_funct3}: ALUCode<=alu_or;
    {1'b0,3'o4,AND_funct3}: ALUCode<=alu_and;
//
    {1'bx,3'o2,ADDI_funct3}: ALUCode<=alu_add;
    {1'bx,3'o2,SLLI_funct3}: ALUCode<=alu_sll;
    {1'bx,3'o2,SLTI_funct3}: ALUCode<=alu_slt;
    {1'bx,3'o2,SLTIU_funct3}: ALUCode<=alu_sltu;
    {1'bx,3'o2,XORI_funct3}: ALUCode<=alu_xor;
    {1'b0,3'o2,SRLI_funct3}: ALUCode<=alu_srl;
    {1'b1,3'o2,SRAI_funct3}: ALUCode<=alu_sra;
    {1'bx,3'o2,ORI_funct3}:  ALUCode<=alu_or;
    {1'bx,3'o2,ANDI_funct3}: ALUCode<=alu_and;
//
    {1'bx,3'o1,3'bxxx}:      ALUCode<=alu_lui;
    default: ALUCode<=alu_sub;
  endcase

//build up Immediate generation
  Shift<=(funct3==3'd1)||(funct3==3'd5);
  if(I_type)  begin Imm<=(Shift)?{26'd0,Instruction[25:20]}:{{20{Instruction[31]}},Instruction[31:20]}; 
                    offset<=32'h00000000; end
  else if(LW)      begin Imm<={{20{Instruction[31]}},Instruction[31:20]}; 
                    offset<=32'h00000000; end
  else if(JALR)    begin Imm<=32'h00000000; 
                    offset<={{20{Instruction[31]}},Instruction[31:20]}; end
  else if(SW)      begin Imm<={{20{Instruction[31]}},Instruction[31:25],Instruction[11:7]}; 
                    offset<=32'h00000000; end
  else if(JAL)     begin Imm<=32'h00000000; 
                    offset<={{11{Instruction[31]}},Instruction[31],Instruction[19:12],Instruction[20],Instruction[30:21],1'b0}; end
  else if(LUI||AUIPC)     begin Imm<={Instruction[31:12],12'd0}; 
                    offset<=32'h00000000; end
  else if(SB_type) begin Imm<=32'h00000000; 
                    offset<={{19{Instruction[31]}},Instruction[31],Instruction[7],Instruction[30:25],Instruction[11:8],1'b0}; end
  else begin
    Imm<=32'h00000000;offset<=32'h00000000; end

end


	 
endmodule