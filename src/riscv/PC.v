//******************************************************************************
// PC.v
//******************************************************************************
module PC(PC_in, clk, reset, en, PC_out);

    input [31:0] PC_in;
    input clk, reset, en;
    output reg [31:0] PC_out;

    always@(posedge clk) begin
        if(reset) PC_out<=32'd0;
        else if(en) PC_out<=PC_in;
    end
endmodule