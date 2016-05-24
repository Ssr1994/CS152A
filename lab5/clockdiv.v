`timescale 1ns / 1ps

module clockdiv(
	input clk,		//master clock: 50MHz
	input clr,		//asynchronous reset
	output dclk,	//pixel clock: 25MHz
	output segclk	//7-segment clock: 763Hz
	);

reg [16:0] q;

initial q = 0;

always @(posedge clk or posedge clr) begin
	if (clr == 1)
		q <= 0;
	else
		q <= q + 1;
end

// 100Mhz ÷ 2^17 = 763Hz
assign segclk = q[16];

// 100Mhz ÷ 2^2 = 25MHz
assign dclk = q[1];

endmodule
