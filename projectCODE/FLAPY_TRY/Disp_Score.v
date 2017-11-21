`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:51:01 01/05/2017 
// Design Name: 
// Module Name:    Disp_Score 
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
module Disp_Score(
	input wire system_clk,
	input wire game_clk,
	input wire reset,
	input wire [9:0] bird_pic_l,
	input wire [9:0] bird_pic_r,
	input wire [9:0] bird_pic_t,
	input wire [9:0] bird_pic_b,
	input wire [9:0] pipe_high_pic_r,
	input wire [9:0] pipe_high_pic_l,
	input wire [9:0] pipe_low_pic_t,
	input wire [9:0] pipe_high_pic_b,
	input wire [9:0] ypipe_high_pic_r,
	input wire [9:0] ypipe_high_pic_l,
	input wire [9:0] ypipe_low_pic_t,
	input wire [9:0] ypipe_high_pic_b,
	output wire [3:0] AN,
	output wire [7:0] Segment,
	//output wire Buzzer,
	output wire [15:0] score
    );
	 
   wire [15:0] cnt;
	reg pass;
	wire [31:0] clk_div;
	initial 	pass = 0;
	always @(posedge game_clk) begin // if bird flies throung the gap of pipe
		if( ((bird_pic_l >= pipe_high_pic_l) & (bird_pic_r <= pipe_high_pic_r)
		& (bird_pic_t >= pipe_high_pic_b) & (bird_pic_b <= pipe_low_pic_t)) |
		((bird_pic_l >= ypipe_high_pic_l) & (bird_pic_r <= ypipe_high_pic_r)
		& (bird_pic_t >= ypipe_high_pic_b) & (bird_pic_b <= ypipe_low_pic_t)))
		pass = 1;
		else pass = 0;
	end
	
	//assign Buzzer = 1'b1;
   clkdiv clk3(.rst(reset),.clk(system_clk),.clkdiv(clk_div));
	CountScore m0(.rst(reset),.pass(pass), .score(cnt)); // output the count 
	DispNum m1(.clk(system_clk), .HEXS(cnt), .LES(4'b0),  .points(4'b0), .RST(1'b0),.AN(AN),.Segment(Segment));

   assign score = cnt;
endmodule
