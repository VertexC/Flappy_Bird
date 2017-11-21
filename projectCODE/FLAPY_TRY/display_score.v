`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:21:47 01/02/2017 
// Design Name: 
// Module Name:    display_score 
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
module display_score(
     input [15:0]score,
	  input clk_25,clk,
	  output [7:0]seg,
	  output reg [7:0]an
    );//display of the score
reg[3:0]data2;
reg [2:0] choice=0;
Segment seg1(.dat(data2),.seg(seg),.clk(clk));// the realize of the segment
always@(posedge clk_25)begin
    case(choice)
	    3'b000:begin data2<=score[3:0];an<=8'b11111110; choice<=choice+1; end
       3'b001:begin data2<=score[7:4];an<=8'b11111101; choice<=choice+1;end
		 3'b010:begin data2<=score[11:8];an<=8'b11111011; choice<=choice+1; end
		 3'b011:begin data2<=score[15:12];an<=8'b11110111;choice<= 0; end
    endcase
end
endmodule
