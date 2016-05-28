`timescale 1ns / 1ps

module fDown_tb;

	// Inputs
	reg clk;
	reg rst;
	reg btnS;
	reg btnL;
	reg btnR;

	// Outputs
	wire [2:0] red;
	wire [2:0] green;
	wire [1:0] blue;
	wire hsync;
	wire vsync;
	wire [7:0] seg;
	wire [3:0] an;

	// Instantiate the Unit Under Test (UUT)
	fDown uut (
		.clk(clk), 
		.rst(rst), 
		.btnS(btnS), 
		.btnL(btnL), 
		.btnR(btnR), 
		.red(red), 
		.green(green), 
		.blue(blue), 
		.hsync(hsync), 
		.vsync(vsync), 
		.seg(seg), 
		.an(an)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		btnS = 0;
		btnL = 0;
		btnR = 0;
		rst = 1;
        
		#50
		rst = 0;

	end
	
	always #5 clk = ~clk;
      
endmodule

