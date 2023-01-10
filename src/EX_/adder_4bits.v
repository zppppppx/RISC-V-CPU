module adder_4bits(a, b, s, ci, co);
	
	input [3:0] a, b;
	input ci;
	output reg [3:0] s;
	output reg co;
	
	reg [3:0] G, P;
	reg [4:0] C, C_;
	
	always@(*)
	begin
		G <= a & b;
		P <= a | b;
		C[0] <= G[0] | P[0]&ci;
		C[1] <= G[1] | P[1]&G[0] | P[1]&P[0]&ci;
		C[2] <= G[2] | P[2]&G[1] | P[2]&P[1]&G[0] | P[2]&P[1]&P[0]&ci;
		C[3] <= G[3] | P[3]&G[2] | P[3]&P[2]&G[1] | P[3]&P[2]&P[1]&G[0] | P[3]&P[2]&P[1]&P[0]&ci;
		C_ <= {C[2],C[1],C[0],ci};
		s <= P&~G^C_;
		co <= C[3];
	end
endmodule
	