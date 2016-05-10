`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:12:30 05/03/2016 
// Design Name: 
// Module Name:    FSM 
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
module fsm(
	input clk,
	input sel,
	input adj,
	output [1:0] state);

	reg [1:0] cur_state;

`include "clk_definitions.v"
	
	always @ (posedge clk)
		if (adj)
			if (sel)
				cur_state = adjust_sec;
			else
				cur_state = adjust_min;
		else
			cur_state = normal;
	
	assign state = cur_state;

endmodule
