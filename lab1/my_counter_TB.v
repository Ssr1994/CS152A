`timescale 1ns / 1ps

module my_counter_TB;

	// Inputs
	reg rst, clk;

	// Outputs
	wire a0, a1, a2, a3;

	// Instantiate the Unit Under Test (UUT)
	my_counter uut (
		.a0(a0), 
		.a1(a1), 
		.a2(a2), 
		.a3(a3), 
		.rst(rst), 
		.clk(clk)
	);

	initial begin
		// Initialize Inputs
		rst = 1;
		clk = 0;
    
		#2 rst = 0;
		// Add stimulus here

	end
	
	always #5 clk = ~clk;
      
endmodule

