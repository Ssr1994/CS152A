`timescale 1ns / 1ps

module led_flash_TB;

	wire [3:0] led;
	reg clk, rst;

	// Instantiate the Unit Under Test (UUT)
	led_flash uut (
		.led(led),
		.clk(clk), 
		.rst(rst)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		
		#2 rst = 0;
		// Add stimulus here
	end
   
	always #5 clk = ~clk;
	
endmodule
