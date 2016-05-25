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
reg [29:0] floorsYPos;
reg [29:0] gapsPos;
reg [29:0] gapsWidth;

reg [9:0] floorsSpeed;
reg [9:0] ballVel; // velocity, ie., speed with direction

initial begin
	xPos = 120;
	yPos = 240;
	floorsYPos = {10'h064, 10'h0FA, 10'h190}; // 300, 500, 700
	gapsPos = {10'h0C8, 10'h12C, 10'h096}; // 200, 300, 150
	gapsWidth = {10'h028, 10'h023, 10'h03C}; // 40, 35, 60
	floorsSpeed = 10'h002;
	ballVel = 10'h000;
end

clockdiv freqs(clk, 0, dclk, segclk);
vga VGA(dclk, 0, hsync, vsync, hc, vc, f);
moveDir movedir(clk, f, btnL, btnR, dir);
drawBall ball(hc, vc, xPos, yPos, rBall, gBall, bBall);
drawFloors floors(hc, vc, floorsYPos, gapsPos, gapsWidth, rFloors, gFloors, bFloors);

always @ (posedge f) begin
	if (dir == 2'b10 && xPos > 0
		&& (yPos - ballRadius >= floorsYPos[29:20] + floorThick || floorsYPos[29:20] >= yPos + ballRadius || xPos >= floorsXPos[29:20] + ballRadius + ballSpeed)
		&& (yPos - ballRadius >= floorsYPos[19:10] + floorThick || floorsYPos[19:10] >= yPos + ballRadius || xPos >= floorsXPos[19:10] + ballRadius + ballSpeed)
		&& (yPos - ballRadius >= floorsYPos[9:0] + floorThick || floorsYPos[9:0] >= yPos + ballRadius || xPos >= floorsXPos[9:0] + ballRadius + ballSpeed))
		xPos <= xPos - ballSpeed;
	else if (dir == 2'b01 && xPos < 640
		&& (yPos - ballRadius >= floorsYPos[29:20] + floorThick || floorsYPos[29:20] >= yPos + ballRadius || xPos + ballSpeed >= floorsXPos[29:20] + ballRadius)
		&& (yPos - ballRadius >= floorsYPos[19:10] + floorThick || floorsYPos[19:10] >= yPos + ballRadius || xPos + ballSpeed >= floorsXPos[19:10] + ballRadius)
		&& (yPos - ballRadius >= floorsYPos[9:0] + floorThick || floorsYPos[9:0] >= yPos + ballRadius || xPos + ballSpeed >= floorsXPos[9:0] + ballRadius))
		xPos <= xPos + ballSpeed;
	else
		xPos <= xPos;
end

always @ (posedge f)
	if (floorsYPos[29:20] > floorsSpeed)
		floorsYPos <= floorsYPos - {3{floorsSpeed}};
	else
		floorsYPos <= {floorsYPos[19:10], floorsYPos[9:0], floorsYPos[9:0] + 10'h0C8} - {3{floorsSpeed}};

assign red = rBall + rFloors;
assign green = gBall + gFloors;
assign blue = bBall + bFloors;

endmodule
