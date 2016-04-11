`timescale 1ns / 1ps

module modern_counter_TB;

	reg clk, rst;

	// Instantiate the Unit Under Test (UUT)
	modern_counter uut (
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

