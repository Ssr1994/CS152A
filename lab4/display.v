`timescale 1ns / 1ps

module display(
	input clk,
	input clk_blink,
	input [1:0] state,
	input [5:0] min,
	input [5:0] sec,
	output [7:0] seg,
	output [3:0] an);
	
	reg off;
	reg [3:0] num;
	reg [3:0] anode;
	
	`include "clk_definitions.v"
	
	convert_seg cvt (num, seg);
	
	initial begin
		anode = 4'b1110;
		off_min = 1'b0;
		off_sec = 1'b0;
	end
	
	always @(posedge clk_blink)
		if (state == adjust_min)
			off_min = ~off_min;
		else
			off_min = 1'b0;

	always @(posedge clk_blink)
		if (state == adjust_sec)
			off_sec = ~off_sec;
		else
			off_sec = 1'b0;
	
	always @(posedge clk) begin
		anode = {anode[0], anode[3:1]};
		case(anode)
			4'b0111: num = off_min ? 4'hF : min/10;
			4'b1011: num = off_min ? 4'hF : min%10;
			4'b1101: num = off_sec ? 4'hF : sec/10;
			4'b1110: num = off_sec ? 4'hF : sec%10;
		endcase
	end
	
	assign an = anode;
	
endmodule
