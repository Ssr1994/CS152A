`timescale 1ns / 1ps

module moveDir(
	input clk,
	input rst,
	input f,
	input btnL,
	input btnR,
	output reg [1:0] dir // 00 or 11 -- stay, 01 -- right, 10 -- left
	);

reg [1:0] dir_temp;

always @ (posedge clk or posedge rst)
	if (rst == 1)
		dir_temp <= 2'b00;
	else
		dir_temp <= {btnL, btnR};

always @ (posedge f) dir <= dir_temp;

endmodule
