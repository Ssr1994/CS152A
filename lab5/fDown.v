`timescale 1ns / 1ps

module fDown(
	input clk,
	input rst,
	input btnS,
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
wire [9:0] randWidth;
wire [9:0] randPos;
reg [9:0] rand6; // 63 max
reg [9:0] rand8; // 1023 max

reg step_d;
reg pause;

`include "definitions.v"

clockdiv freqs(clk, rst, dclk, segclk);
vga VGA(dclk, rst, hsync, vsync, hc, vc, f);
moveDir movedir(clk, rst, f, btnL, btnR, dir);
drawBall ball(hc, vc, xPos, yPos, rBall, gBall, bBall);
drawFloors floors(hc, vc, floorsYPos, gapsPos, gapsWidth, rFloors, gFloors, bFloors);

always @ (posedge f) begin
	rand6 <= {rand6[9:6], rand6[4:0], rand6[5] ^ rand6[4]};
	rand8 <= {rand8[9:8], rand8[6:0], rand8[7] ^ rand8[5] ^ rand8[4] ^ rand8[3]};
end

assign randWidth = rand6 + gapWidthMin;
assign randPos = rand6 + rand8;

always @ (posedge f or posedge rst) begin
	if (rst == 1) begin
		xPos <= 120;
		yPos <= 240;
		floorsYPos <= {10'h12C, 10'h1F4, 10'h2BC}; // 300, 500, 700
		gapsPos <= {10'h0C8, 10'h12C, 10'h096}; // 200, 300, 150
		gapsWidth <= {10'h050, 10'h064, 10'h078}; // 80, 100, 120
		floorsSpeed <= 10'h002;
	end
	else if (~pause) begin
		if (floorsYPos[29:20] > floorsSpeed)
			floorsYPos <= floorsYPos - {3{floorsSpeed}};
		else begin
			floorsYPos <= {floorsYPos[19:10], floorsYPos[9:0], floorsYPos[9:0] + 10'h0C8} - {3{floorsSpeed}};
			gapsPos <= {gapsPos[19:10], gapsPos[9:0], gapsPos[29:20]};
			gapsWidth <= {gapsWidth[19:10], gapsWidth[9:0], randWidth};
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
		else if (floorsYPos[29:20] >= yPos && ballRadius + floorsSpeed > floorsYPos[29:20] - yPos && (xPos < gapsPos[29:20] + ballRadius || xPos + ballRadius > gapsPos[29:20] + gapsWidth[29:20]))
			yPos <= floorsYPos[29:20] - floorsSpeed - ballRadius;
		else if (floorsYPos[19:10] >= yPos && ballRadius + floorsSpeed > floorsYPos[19:10] - yPos && (xPos < gapsPos[19:10] + ballRadius || xPos + ballRadius > gapsPos[19:10] + gapsWidth[19:10]))
			yPos <= floorsYPos[19:10] - floorsSpeed - ballRadius;
		else if (floorsYPos[9:0] >= yPos && ballRadius + floorsSpeed > floorsYPos[9:0] - yPos && (xPos < gapsPos[9:0] + ballRadius || xPos + ballRadius > gapsPos[9:0] + gapsWidth[9:0]))
			yPos <= floorsYPos[9:0] - floorsSpeed - ballRadius;
		else if (yPos + ballRadius >= va)
			yPos <= va - ballRadius;
		else
			yPos <= yPos + ballSpeed;
	end
end

always @ (posedge segclk) begin
	step_d <= btnS;
	if (btnS & ~step_d)
		pause <= ~pause;
end

assign red = rBall + rFloors;
assign green = gBall + gFloors;
assign blue = bBall + bFloors;

endmodule
