`timescale 1ns / 1ps

module drawBall(
	input [9:0] hc,
	input [9:0] vc,
	input [9:0] xPos,
	input [9:0] yPos,
	output [2:0] r,
	output [2:0] g,
	output [1:0] b
	);

`include "definitions.v"
wire active;

assign active = (ballRadius * ballRadius >= (hc - xPos) * (hc - xPos) + (vc - yPos) * (vc - yPos));
assign r = active ? 3'b111 : 3'b000;
assign g = (active && yPos) ? 3'b111 : 3'b000;
assign b = (active && yPos) ? 3'b11 : 3'b00;

endmodule
