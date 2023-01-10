module  IF_ID(clk, en, reset, PC_id, PC_if, Instruction_if, Instruction_id);

    input clk, en, reset;
    input[31:0] PC_if, Instruction_if;
    output reg [31:0] PC_id=0, Instruction_id=0;

    always@(posedge clk) begin
        if(reset) begin PC_id<=32'd0; Instruction_id<=32'd0; end
        else begin
            if(en)  begin PC_id<=PC_if; Instruction_id<=Instruction_if; end
        end
    end
endmodule