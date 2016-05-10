`timescale 1ns / 1ps

module clock(
	input clk,
	input pause,
	input rst,
	output clk_normal, // 1Hz
	output clk_adjust, // 2Hz
	output clk_fast, // 200Hz
	output clk_blink); // 2.5Hz
	
	reg [26:0] counter_adjust;
	always @ (posedge clk or posedge rst) begin
		//count to 10^8/2
		if (rst || counter_adjust == 27'h2FAF080)
			counter_adjust  <= 1'b1;
		else if (~pause)
			counter_adjust  <= counter_adjust + 1'b1;
	end

	assign clk_adjust = (counter_adjust == 27'h2FAF080);      

	//1 Hz Counter
	reg [26:0] counter_normal;
	always @ (posedge clk or posedge rst) begin
		//count to 10^8
		if (rst || counter_normal == 27'h5F5E100)
			counter_normal <= 1'b1;
		else if (~pause)
			counter_normal <= counter_normal + 1'b1;
	end

	assign clk_normal = (counter_normal == 27'h5F5E100);

	//200 Hz Counter
	reg [26:0] counter_fast;
	always @ (posedge clk or posedge rst) begin
		//count to 10^8/200
		if (rst || counter_fast == 27'h7A120)
			counter_fast <= 1'b1;
		else
			counter_fast <= counter_fast + 1'b1;
	end

	assign clk_fast = (counter_fast == 27'h7A120);


	//5 Hz Counter
	reg [26:0] counter_blink;
	always @ (posedge clk or posedge rst) begin
		//count to 10^8/5
		if (rst || counter_blink == 27'h1312D00)
			counter_blink <= 1'b1;
		else if (~pause)
			counter_blink <= counter_blink + 1'b1;
	end

	assign clk_blink = (counter_blink == 27'h1312D00);
		
endmodule
