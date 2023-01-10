module add_sel(a, b, ci, co, s);
	input[3:0] a, b;
	input ci;
	output [3:0] s;
	output co;
	
	wire [2:0] C;
	wire [3:0] s0, s1;
	
	adder_4bits adder1(.a(a), .b(b), .ci(1'b0), .s(s0), .co(C[0]));
	adder_4bits adder2(.a(a), .b(b), .ci(1'b1), .s(s1), .co(C[1]));
	
	assign s = ci?s1:s0;
	//mux4_1 mux(.ina(s0), .inb(s1), .addr(ci), .out(s));
	
	assign co = C[0] | C[1]&ci;
endmodule