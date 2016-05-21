`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:00:08 05/19/2016 
// Design Name: 
// Module Name:    fDown 
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
module fDown(
	input clk,
	output [2:0] red,
	output [2:0] green,
	output [1:0] blue,
	output hsync,
	output vsync
	);
	
wire dclk;
wire [9:0] hc;
wire [9:0] vc;
reg [9:0] xPos;
reg [9:0] yPos;
reg [9:0] fYPos1;
reg [9:0] gapPos1;
reg [9:0] gapWidth1;

initial begin
	xPos = 320;
	yPos = 240;
	fYPos1 = 200;
	gapPos1 = 200;
	gapWidth = 40;
end

clockdiv freqs(clk, 0, dclk);
vga VGA(dclk, 0, hsync, vsync, hc, vc);
drawBall ball(hc, vc, xPos, yPos, red, green, blue);
drawFloor floor1(hc, vc, fYPos1, gapPos1, gapWidth1, red, green, blue);

endmodule
