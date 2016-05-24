`timescale 1ns / 1ps

module moveBall(
	input clk,
	input f,
	input btnL,
	input btnR,
	output [1:0] dir // 00 or 11 -- stay, 01 -- right, 10 -- left
	);

reg [1:0] dir_temp;

initial dir_temp = 2'b00;

always @ (clk) dir_temp = {btnL, btnR};

always @ (f) dir = dir_temp;

endmodule
