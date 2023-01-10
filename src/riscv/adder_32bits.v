module adder_32bits(a, b, ci, s, co);
	input [31:0] a, b;
	input ci;
	output [31:0] s;
	output co;
	
	wire [6:0] C;
	wire [32:0] temp;
	
	adder_4bits adder0(.a(a[3:0]), .b(b[3:0]), .ci(ci), .s(s[3:0]), .co(C[0]));
	
	add_sel adder1(.a(a[7:4]), .b(b[7:4]), .ci(C[0]), .co(C[1]), .s(s[7:4]));
	add_sel adder2(.a(a[11:8]), .b(b[11:8]), .ci(C[1]), .co(C[2]), .s(s[11:8]));
	add_sel adder3(.a(a[15:12]), .b(b[15:12]), .ci(C[2]), .co(C[3]), .s(s[15:12]));
	add_sel adder4(.a(a[19:16]), .b(b[19:16]), .ci(C[3]), .co(C[4]), .s(s[19:16]));
	add_sel adder5(.a(a[23:20]), .b(b[23:20]), .ci(C[4]), .co(C[5]), .s(s[23:20]));
	add_sel adder6(.a(a[27:24]), .b(b[27:24]), .ci(C[5]), .co(C[6]), .s(s[27:24]));
	add_sel adder7(.a(a[31:28]), .b(b[31:28]), .ci(C[6]), .co(co), .s(s[31:28]));
	
	assign temp=a+b+ci;
	
endmodule
	