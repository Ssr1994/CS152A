`timescale 1ns / 1ps

module twos_complement(
	input [11:0] D,
	output reg S,
	output reg [11:0] D_t
);
	
	always @ (*) begin
		S = D[11];
		D_t = S ? (~D + 1) : D;
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
		i = (((~& D[10:4]) & (| D[3:0])) << 3)
			+ (((~& D[10:8]) & (| D[7:4])) << 2)
			+ (((~D[10]) & ((| D[9:8]) | ((~& D[7:6]) & (| D[5:4])))) << 1)
			+ (D[10] | ((~D[9]) & (D[8] | ((~D[7]) | (D[6] | (~D[5] & D[4]))))));
	
		E = 4'b1000 - i;
		F = D >> (4'b1000 - i);
		fifth_bit = D >> (i + 4'b0100);
	end
	
endmodule


module FP_rounding(
	input [2:0] E,
	input [3:0] F,
	input fifth_bit,
	output reg [2:0] E_f,
	output reg [3:0] F_f
);

	reg F_full;
	
	always @ (*) begin
		F_full = (F == 4'b1111);
		E_f = (fifth_bit && F_full) ? E + 1'b1 : E;
		F_f = fifth_bit ? (F_full ? 4'b1000 : (F + 1'b1)) : F;
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
