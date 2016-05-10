`timescale 1ns / 1ps

module convert_seg(
	input [3:0] number,
	output [7:0] seg);

	reg [7:0] segNum;

	always @ (*)
		case(number) //0 means on 1 means off
			0: segNum = 8'b11000000;
			1: segNum = 8'b11111001;
			2: segNum = 8'b10100100;
			3: segNum = 8'b10110000;
			4: segNum = 8'b10011001;
			5: segNum = 8'b10010010;
			6: segNum = 8'b10000010;
			7: segNum = 8'b11111000;
			8: segNum = 8'b10000000;
			9: segNum = 8'b10010000;
			default: segNum = 8'b11111111;
		endcase
	
	assign seg = segNum;

endmodule