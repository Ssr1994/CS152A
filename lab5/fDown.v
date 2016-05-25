`timescale 1ns / 1ps

module fDown(
	input clk,
	input btnL,
	input btnR,
	output [2:0] red,
	output [2:0] green,
	output [1:0] blue,
	output hsync,
	output vsync
	);
	
wire dclk;
wire segclk;
wire [9:0] hc;
wire [9:0] vc;
wire f; // one frame
wire [1:0] dir; // the direction the user intended

// Colors
wire [2:0] rBall;
wire [2:0] gBall;
wire [1:0] bBall;
wire [2:0] rFloors;
wire [2:0] gFloors;
wire [1:0] bFloors;

// Ball's position
reg [9:0] xPos;
reg [9:0] yPos;

// Floors' and gaps' positions (3 floors)
reg [29:0] floorsYPos; // upper
reg [29:0] gapsPos; // left
reg [29:0] gapsWidth;

reg [9:0] floorsSpeed;
reg [9:0] ballVel; // velocity, ie., speed with direction

`include "definitions.v"

initial begin
	xPos = 120;
	yPos = 240;
	floorsYPos = {10'h12C, 10'h1F4, 10'h2BC}; // 300, 500, 700
	gapsPos = {10'h0C8, 10'h12C, 10'h096}; // 200, 300, 150
	gapsWidth = {10'h050, 10'h064, 10'h078}; // 80, 100, 120
	floorsSpeed = 10'h002;
	ballVel = 10'h000;
end

clockdiv freqs(clk, 0, dclk, segclk);
vga VGA(dclk, 0, hsync, vsync, hc, vc, f);
moveDir movedir(clk, f, btnL, btnR, dir);
drawBall ball(hc, vc, xPos, yPos, rBall, gBall, bBall);
drawFloors floors(hc, vc, floorsYPos, gapsPos, gapsWidth, rFloors, gFloors, bFloors);

always @ (posedge f) begin
	if (floorsYPos[29:20] > floorsSpeed)
		floorsYPos <= floorsYPos - {3{floorsSpeed}};
	else begin
		floorsYPos <= {floorsYPos[19:10], floorsYPos[9:0], floorsYPos[9:0] + 10'h0C8} - {3{floorsSpeed}};
		gapsPos <= {gapsPos[19:10], gapsPos[9:0], gapsPos[29:20]};
		gapsWidth <= {gapsWidth[19:10], gapsWidth[9:0], gapsWidth[29:20]};
	end

	if (dir == 2'b10 && xPos > ballSpeed
		&& (yPos >= floorsYPos[29:20] + floorThick + ballRadius || floorsYPos[29:20] >= yPos + ballRadius || xPos >= gapsPos[29:20] + ballRadius + ballSpeed)
		&& (yPos >= floorsYPos[19:10] + floorThick + ballRadius || floorsYPos[19:10] >= yPos + ballRadius || xPos >= gapsPos[19:10] + ballRadius + ballSpeed)
		&& (yPos >= floorsYPos[9:0] + floorThick + ballRadius || floorsYPos[9:0] >= yPos + ballRadius || xPos >= gapsPos[9:0] + ballRadius + ballSpeed))
		xPos <= xPos - ballSpeed;
	else if (dir == 2'b01 && xPos < ha
		&& (yPos >= floorsYPos[29:20] + floorThick + ballRadius || floorsYPos[29:20] >= yPos + ballRadius || gapsPos[29:20] + gapsWidth[29:20] >= xPos + ballRadius + ballSpeed)
		&& (yPos >= floorsYPos[19:10] + floorThick + ballRadius || floorsYPos[19:10] >= yPos + ballRadius || gapsPos[19:10] + gapsWidth[19:10] >= xPos + ballRadius + ballSpeed)
		&& (yPos >= floorsYPos[9:0] + floorThick + ballRadius || floorsYPos[9:0] >= yPos + ballRadius || gapsPos[9:0] + gapsWidth[9:0] >= xPos + ballRadius + ballSpeed))
		xPos <= xPos + ballSpeed;

	if (yPos < floorsSpeed)
		// game over
		yPos <= 0;
	else if (yPos + ballRadius >= ha)
		yPos <= ha - ballRadius;
	else if (floorsYPos[29:20] >= yPos && ballRadius > floorsYPos[29:20] - yPos && (xPos < gapsPos[29:20] + ballRadius || xPos + ballRadius > gapsPos[29:20] + gapsWidth[29:20]))
		yPos <= floorsYPos[29:20] - floorsSpeed - ballRadius;
	else if (floorsYPos[19:10] >= yPos && ballRadius > floorsYPos[19:10] - yPos && (xPos < gapsPos[19:10] + ballRadius || xPos + ballRadius > gapsPos[19:10] + gapsWidth[19:10]))
		yPos <= floorsYPos[19:10] - floorsSpeed - ballRadius;
	else if (floorsYPos[9:0] >= yPos && ballRadius > floorsYPos[9:0] - yPos && (xPos < gapsPos[9:0] + ballRadius || xPos + ballRadius > gapsPos[9:0] + gapsWidth[9:0]))
		yPos <= floorsYPos[9:0] - floorsSpeed - ballRadius;
	else
		yPos <= yPos + ballSpeed;
end

assign red = rBall + rFloors;
assign green = gBall + gFloors;
assign blue = bBall + bFloors;

endmodule
