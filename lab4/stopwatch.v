`timescale 1ns / 1ps

module stopwatch(
	input clk,
	input [1:0] sw, // [adj, sel]
	input btnS,
	input btnR,
	output [7:0] seg,
	output [3:0] an);
	
	wire clk_normal, clk_adjust, clk_fast, clk_blink;
	reg sec_clk_freq, min_clk_freq;
	wire [5:0] sec;
	wire [5:0] min;
	wire [1:0] state;
	wire overflow;
	wire ignore;
	reg pause;
	reg sel;
	
	wire [17:0] clk_dv_inc;
   reg [16:0]  clk_dv;
   reg         clk_en;
   reg         clk_en_d;
   reg [2:0]   step_d;
	
	`include "clk_definitions.v"
	
	clock freqs(clk, pause, btnR, clk_normal, clk_adjust, clk_fast, clk_blink);
	
	counter sec_cnt(btnR, sec_clk_freq, sec, overflow);
	counter min_cnt(btnR, min_clk_freq, min, ignore);
	
	display num_display(clk_fast, clk_blink, state, min, sec, seg, an);
	
	fsm fsm(clk, sw[0], sw[1], state);
	
	always @(posedge clk) begin
		case (state)
			adjust_min: begin
				min_clk_freq = clk_adjust;
				sec_clk_freq = 1'b0;
			end
			adjust_sec: begin
				min_clk_freq = 1'b0;
				sec_clk_freq = clk_adjust;
			end
			default: begin
				min_clk_freq = overflow;
				sec_clk_freq = clk_normal;
			end
		endcase
	end
	

	assign clk_dv_inc = clk_dv + 1;
   
   always @ (posedge clk) begin
		clk_dv   <= clk_dv_inc[16:0];
		clk_en   <= clk_dv_inc[17];
		clk_en_d <= clk_en;
	end
	
	always @ (posedge clk)
		if (clk_en)
			step_d[2:0]  <= {btnS, step_d[2:1]};
	
	always @ (posedge clk)
		if (~step_d[0] & step_d[1] & clk_en_d)
			pause = ~pause;
	
endmodule
