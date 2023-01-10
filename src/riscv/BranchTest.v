//******************************************************************************
// //
// BranchTest.v
//******************************************************************************
module BranchTest(
    //inputs
    rs1Data, rs2Data, Instruction,
    //outputs
    Branch);

    input [31:0] rs1Data, rs2Data, Instruction;

    output reg Branch;

    //funct3 codes
    parameter beq_funct3=3'o0;
    parameter bne_funct3=3'o1;
    parameter blt_funct3=3'o4;
    parameter bge_funct3=3'o5;
    parameter bltu_funct3=3'o6;
    parameter bgeu_funct3=3'o7;
    parameter SB_type_op=7'b1100011;
    

    wire [31:0] sum;
    wire [2:0] funct3;
    wire isLT, isLTU, SB_type;
    //assign funct3 codes
    assign funct3 = Instruction[14:12];

    //rs1Data - rs2Data to sum
    adder_32bits adder_inst(.a(rs1Data), .b(~(rs2Data)+1), .ci(1'b0), .s(sum), .co());

    //assign isLT and isLTU
    assign isLT=(~rs2Data[31])&&rs1Data[31]||(rs1Data[31]~^rs2Data[31])&&sum[31];
    assign isLTU=(~rs1Data[31])&&rs2Data[31]||(rs1Data[31]~^rs2Data[31])&&sum[31];

    //assign flag SB_type
    assign SB_type=(Instruction[6:0]==SB_type_op);

    //define the output Branch
    always @(*) begin
        if(SB_type&&(funct3==beq_funct3)) begin
            Branch<=~(|sum[31:0]);
        end
        else if(SB_type&&(funct3==bne_funct3)) begin
            Branch<=|sum[31:0];
        end
        else if(SB_type&&(funct3==blt_funct3)) begin
            Branch<=isLT;
        end
        else if(SB_type&&(funct3==bge_funct3)) begin
            Branch<=~isLT;
        end
        else if(SB_type&&(funct3==bltu_funct3)) begin
            Branch<=isLTU;
        end
        else if(SB_type&&(funct3==bgeu_funct3)) begin
            Branch<=~isLTU;
        end
        else begin
            Branch=1'b0;
        end
    end
endmodule


    
    