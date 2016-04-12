`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:11:48 04/12/2016
// Design Name:   floating_point
// Module Name:   E:/CS152A/test/floating_point_TB.v
// Project Name:  test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: floating_point
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module floating_point_TB;

	// Inputs
	reg [11:0] D;

	// Outputs
	wire S;
	wire [2:0] E;
	wire [3:0] F;

	// Instantiate the Unit Under Test (UUT)
	floating_point uut (
		.S(S), 
		.E(E), 
		.F(F), 
		.D(D)
	);

	initial begin
		// Initialize Inputs
		D = 0;
	end
   
	always #10 D = D + 3'b111;
endmodule

