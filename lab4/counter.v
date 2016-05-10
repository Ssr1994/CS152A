

`timescale 1ns / 1ps

module counter(
	//input pause,
	input rst,
	input clk,
	output [5:0] count,
	output overflow);

	reg [5:0] cnt;
	reg of;

	initial
	begin
		cnt = 0;
		of = 1'b0;
	end
	
	always @ (posedge clk or posedge rst)
	begin
		if (rst == 1'b1)
			cnt = 0;
		else
		begin
			of = 1'b0;
			//if (pause != 1'b1)
			cnt = cnt + 1;
			if (cnt == 60)
			begin
				cnt = 0;
				of = 1'b1;
			end
		end
	end

	assign count = cnt;
	assign overflow = of;

endmodule
