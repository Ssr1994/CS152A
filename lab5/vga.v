`timescale 1ns / 1ps

module vga(
	input dclk,
	input rst,
	output hsync,
	output vsync,
	output reg [9:0] hc, // horizontal pixel counter
	output reg [9:0] vc, // vertical line counter
	output reg f // one frame
  );

`include "definitions.v"

always @(posedge dclk or posedge rst) begin
	// reset condition
	if (rst == 1) begin
		hc <= 0;
		vc <= 0;
		f <= 0;
	end else begin
		f <= 0;
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else begin
				vc <= 0;
				f <= 1;
			end
		end
	end
end

assign hsync = (hc >= ha + hfp && hc < ha + hfp + hp) ? 0:1;
assign vsync = (vc >= va + vfp && vc < va + vfp + vp) ? 0:1;

endmodule
