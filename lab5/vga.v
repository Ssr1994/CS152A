`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:18:59 05/19/2016 
// Design Name: 
// Module Name:    vga 
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
module vga(
	input dclk,
	input clr,
	output hsync,
	output vsync,
	output reg [9:0] hc, // horizontal pixel counter
	output reg [9:0] vc // vertical line counter
   );

`include "definitions.v"

initial begin
	hc = 0;
	vc = 0;
end

always @(posedge dclk or posedge clr) begin
	// reset condition
	if (clr == 1) begin
		hc <= 0;
		vc <= 0;
	end else begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
	end
end

assign hsync = (hc >= ha + hfp && hc < ha + hfp + hp) ? 0:1;
assign vsync = (vc >= va + vfp && vc < va + vfp + vp) ? 0:1;

endmodule
