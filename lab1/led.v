`timescale 1ns / 1ps

module led_flash(led, clk, rst);

	input rst, clk;
	output reg [3:0] led;
	reg [26:0] a;
	wire c;

	always @ (posedge clk or posedge rst) begin
		if (rst || a == 27'h2FAF080)
			a <= 1;
		else
			a <= a + 1'b1;
	end
	
	assign c = (a == 27'h2FAF080);
	
	always @ (posedge c or posedge rst) begin
		if (rst)
			led <= 1'b0;
		else
			led <= led + 1'b1;
	end
		
endmodule
