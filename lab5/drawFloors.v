`timescale 1ns / 1ps

module drawFloors(
	input [9:0] hc,
	input [9:0] vc,
	input [29:0] yPos, // floors' vertical position (lower)
	input [29:0] gapsPos, // gaps' horizontal position (left)
	input [29:0] gapsWidth,
	output [2:0] r,
	output [2:0] g,
	output [1:0] b
	);

`include "definitions.v"
wire active;

assign active = (vc >= yPos[29:20] && vc < yPos[29:20] + floorThick && (hc < gapsPos[29:20] || hc >= gapsPos[29:20] + gapsWidth[29:20]))
	|| (vc >= yPos[19:10] && vc < yPos[19:10] + floorThick && (hc < gapsPos[19:10] || hc >= gapsPos[19:10] + gapsWidth[19:10]))
	|| (vc >= yPos[9:0] && vc < yPos[9:0] + floorThick && (hc < gapsPos[9:0] || hc >= gapsPos[9:0] + gapsWidth[9:0]))	? 1:0;
assign r = active ? 3'b111 : 3'b000;
assign g = active ? 3'b111 : 3'b000;
assign b = active ? 3'b11 : 3'b00;

endmodule
