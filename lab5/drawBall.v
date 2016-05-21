`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:38:55 05/19/2016 
// Design Name: 
// Module Name:    drawBall 
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
assign r = active ? 3'b100 : 3'b000;
assign g = active ? 3'b100 : 3'b000;
assign b = active ? 3'b11 : 3'b00;

endmodule
