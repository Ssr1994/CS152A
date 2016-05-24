`timescale 1ns / 1ps

module fDown(
	input clk,
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

initial begin
	xPos = 320;
	yPos = 240;
	floorsYPos = {10'h064, 10'h0FA, 10'h190}; // 100, 250, 400
	gapsPos = {10'h0C8, 10'h12C, 10'h096}; // 200, 300, 150
	gapsWidth = {10'h028, 10'h023, 10'h03C}; // 40, 35, 60
end

clockdiv freqs(clk, 0, dclk, segclk);
vga VGA(dclk, 0, hsync, vsync, hc, vc, f);
drawBall ball(hc, vc, xPos, yPos, rBall, gBall, bBall);
drawFloors floors(hc, vc, floorsYPos, gapsPos, gapsWidth, rFloors, gFloors, bFloors);

assign red = rBall + rFloors;
assign green = gBall + gFloors;
assign blue = bBall + bFloors;

endmodule
