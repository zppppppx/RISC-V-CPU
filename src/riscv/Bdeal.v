module Bdeal(B, ALUCode, Bout, Binvert);

input[31:0] B;
input[3:0] ALUCode;
output reg[31:0] Bout;
output reg Binvert;
reg [31:0] tempt;
always	@(*) begin
	Binvert <=~(ALUCode==4'b0);
	tempt <= (Binvert==1)?32'hffffffff:32'h00000000;
	Bout <= tempt^B;										//Binvert xor B
end
endmodule