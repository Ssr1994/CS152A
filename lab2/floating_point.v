`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:46:20 04/11/2016 
// Design Name: 
// Module Name:    floating_point 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module floating_point(S, E, F, D);

	input [11:0] D;
	output S, E, F;
	reg S;			 // Sign
	reg [2:0] E; // Exponent
	reg [3:0] F; // Significand
	
	reg [11:0] D_t;
	reg [3:0] i;
	
	always @ (D) begin
		S = D[11];
		D_t = S ? (~D + 1) : D;
		
		i = 4'b0000;
		while (i < 4'd1000 && D_t[4'b1011 - i] == 1'b0)
			i = i + 1'b1;
		D_t = D_t << i;
		
		E = 4'b1000 - i;
		F = D_t[4'b1011:4'b1000];
		
		if (D_t[3'b111]) begin
			if (F == 4'b1111) begin
				F = 4'b1000;
				E = E + 1;
			end else
				F = F + 1;
		end
	end

endmodule
