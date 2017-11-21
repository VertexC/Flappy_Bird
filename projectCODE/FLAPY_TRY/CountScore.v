`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:18:19 01/04/2017 
// Design Name: 
// Module Name:    CountScore 
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
module CountScore(rst, pass, score);
	input wire rst, pass;
	output reg [15:0] score;                // the score is cleaned when rst = 1
	
	initial score = 16'b0;
	
	always @(posedge pass or posedge rst)
		if(rst)
			 score = 16'b0;
		else if(score[15] && score[12] && score[11] && score[8] && score[7] && score[4] && score[0] && score[3])
			score = 16'b0;
		else if(score[11] && score[8] && score[7] && score[4] && score[0] && score[3])
			begin
			score[11:0] = 12'b0;
			score[15:12] = score[15:12] +1;
			end
		else if(score[7] && score[4] && score[0] && score[3])
			begin
			score[7:0] = 8'b0;
			score[11:8] = score[11:8] +1;
			end
		else if(score[0] && score[3])
			begin
			score[3:0] = 4'b0;
			score[7:4] = score[7:4] +1;
			end
		else score = score + 1;

endmodule
