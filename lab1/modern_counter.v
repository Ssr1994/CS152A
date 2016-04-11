`timescale 1ns / 1ps

module modern_counter(clk, rst);

	input rst, clk;
	reg [3:0] a;

	always @ (posedge clk or posedge rst) begin
		if (rst)
			a <= 0;
		else
			a <= a + 1'b1;
	end
		
endmodule
