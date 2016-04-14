`timescale 1ns / 1ps

module twos_complement(
	input [11:0] D,
	output reg S,
	output reg [11:0] D_t
);
	
	always @ (*) begin
		S = D[11];
		D_t = S ? ((| D[10:0]) ? (~D + 1) : ~D) : D;
	end
	
endmodule


module basic_FP_conversion(
	input [11:0] D,
	output reg [2:0] E, // Exponent
	output reg [3:0] F, // Significand
	output reg fifth_bit
);
	
	reg [3:0] i;

	always @ (*) begin
		if (D[10]) i = 4'b0001;
		else if (D[9]) i = 4'b0010;
		else if (D[8]) i = 4'b0011;
		else if (D[7]) i = 4'b0100;
		else if (D[6]) i = 4'b0101;
		else if (D[5]) i = 4'b0110;
		else if (D[4]) i = 4'b0111;
		else i = 4'b1000;
	
		E = 4'b1000 - i;
		F = D >> (4'b1000 - i);
		fifth_bit = D >> (4'b0111 - i);
	end
	
endmodule


module FP_rounding(
	input [2:0] E,
	input [3:0] F,
	input fifth_bit,
	output reg [2:0] E_f,
	output reg [3:0] F_f
);
	
	reg E_full;
	reg F_full;
	
	always @ (*) begin
		E_full = (E == 3'b111);
		F_full = (F == 4'b1111);
		E_f = (fifth_bit && F_full && ~E_full) ? E + 1'b1 : E;
		F_f = fifth_bit ? (F_full ? (E_full ? F : 4'b1000) : (F + 1'b1)) : F;
	end

endmodule


module floating_point(
	input [11:0] D,
	output S,
	output [2:0] E,
	output [3:0] F
);
	
	wire [11:0] D_t;
	wire fifth_bit;
	wire [2:0] E_t;
	wire [3:0] F_t;
	
	twos_complement tc (D, S, D_t);
	basic_FP_conversion bfc (D_t, E_t, F_t, fifth_bit);
	FP_rounding fr (E_t, F_t, fifth_bit, E, F);

endmodule
