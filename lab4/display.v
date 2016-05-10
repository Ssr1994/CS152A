`timescale 1ns / 1ps

module display(
	input clk,
	input clk_blink,
	input [5:0] min,
	input [5:0] sec,
	output [7:0] seg,
	output [3:0] an);
	
	reg off;
	reg [3:0] num;
	reg [3:0] anode;
	
	convert_seg cvt (num, seg);
	
	initial begin
		anode = 4'b1110;
		off = 1'b0;
	end
	
	always @(posedge clk_blink)
		off = ~off;
	
	always @(posedge clk) begin
		anode = {anode[0], anode[3:1]};
		case(anode)
			4'b0111: num = off ? 4'hF : min/10;
			4'b1011: num = off ? 4'hF : min%10;
			4'b1101: num = off ? 4'hF : sec/10;
			4'b1110: num = off ? 4'hF : sec%10;
		endcase
	end
	
	assign an = anode;
	
endmodule
