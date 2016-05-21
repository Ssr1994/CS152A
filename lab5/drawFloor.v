`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:33:37 05/19/2016 
// Design Name: 
// Module Name:    drawFloor 
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
module drawFloor(
	input [9:0] hc,
	input [9:0] vc,
	input [9:0] yPos, // floor vertical position (lower)
	input [9:0] gapPos, // gap horizontal position (left)
	input [9:0] gapWidth,
	output [2:0] r,
	output [2:0] g,
	output [1:0] b
	);

`include "definitions.v"
wire active;

assign active = (vc >= yPos && vc < yPos + floorThick && (hc < gapPos || hc >= gapPos + gapWidth)) ? 1:0;
assign r = active ? 3'b111 : 3'b000;
assign g = active ? 3'b111 : 3'b000;
assign b = active ? 3'b11 : 3'b00;

endmodule
