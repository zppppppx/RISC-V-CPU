module ID_EX(clk, reset, WB_id, WB_ex, M_id, M_ex, EX_id, EX_ex, PC_id, PC_ex, Imm_id, 
            Imm_ex, rdAddr_id, rdAddr_ex, rs1Addr_id, rs1Addr_ex, rs2Addr_id, rs2Addr_ex, 
            rs1Data_id, rs1Data_ex, rs2Data_id, rs2Data_ex);

    input clk, reset;
    input[1:0] WB_id, M_id;
    input[6:0] EX_id;
    input[31:0] PC_id, Imm_id;
    input[4:0] rdAddr_id, rs1Addr_id, rs2Addr_id;
    input[31:0] rs1Data_id, rs2Data_id;

    output reg[1:0] WB_ex=0, M_ex=0;
    output reg[6:0] EX_ex=0;
    output reg[31:0] PC_ex=0, Imm_ex=0;
    output reg[4:0] rdAddr_ex=0, rs1Addr_ex=0, rs2Addr_ex=0;
    output reg[31:0] rs1Data_ex=0, rs2Data_ex=0;

    always@(posedge clk) begin
        if(reset) begin
            WB_ex<=2'd0;
            M_ex<=2'd0;
            EX_ex<=3'd0;
            PC_ex<=32'd0;
            Imm_ex<=32'd0;
            rdAddr_ex<=5'd0;
            rs1Addr_ex<=5'd0;
            rs2Addr_ex<=5'd0;
            rs1Data_ex<=32'd0;
            rs2Data_ex<=32'd0;
        end
        else begin
            WB_ex<=WB_id;
            M_ex<=M_id;
            EX_ex<=EX_id;
            PC_ex<=PC_id;
            Imm_ex<=Imm_id;
            rdAddr_ex<=rdAddr_id;
            rs1Addr_ex<=rs1Addr_id;
            rs2Addr_ex<=rs2Addr_id;
            rs1Data_ex<=rs1Data_id;
            rs2Data_ex<=rs2Data_id;
        end
    end
endmodule
    
