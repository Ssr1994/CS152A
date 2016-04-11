`timescale 1ns / 1ps

module my_counter(a0, a1, a2, a3, rst, clk);
  input rst, clk;
  output reg a0, a1, a2, a3;

  always @(posedge clk or posedge rst) begin
    if(rst)
      a0 <= 1'b0;
    else 
      a0 <= ~a0;
  end
  
  always @(posedge clk or posedge rst) begin
    if(rst)
      a1 <= 1'b0;
    else 
      a1 <= a0 ^ a1;
  end
  
  always @(posedge clk or posedge rst) begin
    if(rst)
      a2 <= 1'b0;
    else 
      a2 <= (a0 & a1) ^ a2;
  end
  
  always @(posedge clk or posedge rst) begin
    if(rst)
      a3 <= 1'b0;
    else 
      a3 <= (a0 & a1 & a2) ^ a3;
  end
endmodule
