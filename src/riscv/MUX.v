module MUX(in0, in1, in2, in3, out, addr);
	
	input [31:0] in0, in1, in2, in3;
	input [1:0] addr;
	output reg [31:0] out;

	always@(*) begin
		case(addr)
			2'b00: out<=in0;
			2'b01: out<=in1;
			2'b10: out<=in2;
			2'b11: out<=in3;
		endcase
	end

endmodule
	
	