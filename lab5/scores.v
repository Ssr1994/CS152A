`timescale 1ns / 1ps

module scores(
	input segclk,
	input rst,
	input hi,
	input [19:0] score,
	input [19:0] highest,
	output [7:0] seg,
	output [3:0] an
	);

reg [3:0] num;
reg [3:0] anode;
reg [7:0] segNum;
integer my_score;

always @(score)
	my_score = hi ? highest[19:2] : score[19:2];

always @ (num)
	case(num) //0 means on 1 means off
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

always @(posedge segclk or posedge rst)
	if (rst)
		anode <= 4'b1110;
	else begin
		anode <= {anode[0], anode[3:1]};
	end

always @(anode)
	case(anode)
		4'b0111: num = my_score % 10000 / 1000;
		4'b1011: num = my_score % 1000 / 100;
		4'b1101: num = my_score % 100 / 10;
		4'b1110: num = my_score % 10;
	endcase

assign seg = segNum;
assign an = anode;

endmodule
