`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:05:02 01/04/2017 
// Design Name: 
// Module Name:    pipe_one_low 
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
module pipe_one_low(
	input wire system_clk,
	input wire game_clk,
	input wire reset,
	input wire [9:0] pixel_x,
	input wire [9:0]pixel_y,
	input wire [9:0]pipe_high_pic_l,
	input wire [9:0]pipe_high_pic_r,
	input wire [9:0]pipe_high_pic_t,
	input wire [9:0]pipe_high_pic_b,
	output wire [9:0]pipe_pic_l,
	output wire [9:0]pipe_pic_r,
	output wire [9:0]pipe_pic_t,
	output wire [9:0]pipe_pic_b,
	output wire [11:0]rgb
);

//pipe_one_low_move move2(
    //input
	//.clk(clk),.reset(reset),
	//.pipe_high_pic_l(pipe_high_pic_l),
	//.pipe_high_pic_r(pipe_high_pic_r),
    //.pipe_high_pic_t(pipe_high_pic_t),
    //.pipe_high_pic_b(pipe_high_pic_b),
	//output
	//.pipe_pic_r(pipe_pic_r),.pipe_pic_l(pipe_pic_l),
	//.pipe_pic_t(pipe_pic_t),.pipe_pic_b(pipe_pic_b))

localparam EVERYLINE_PIPE = 41;
localparam HEIGHT_PIPE = 253;
localparam GAP_PIPE = 70;
localparam MAX_Y = 426;

wire [13:0] position_PIPE;
// move the pipe_one_low according to the pipe_one_high
assign position_PIPE = (pixel_x - pipe_high_pic_l) + (EVERYLINE_PIPE) * (HEIGHT_PIPE - 1 + pipe_pic_t - pixel_y);

wire [11:0] rgb_temp_pipe;

pipe1_low PIPE_1L(
	.clka(system_clk),
	.addra(position_PIPE),
	.douta(rgb_temp_pipe));

assign rgb = rgb_temp_pipe;
assign pipe_pic_l = pipe_high_pic_l;
assign pipe_pic_r = pipe_high_pic_r;
assign pipe_pic_b = MAX_Y;
assign pipe_pic_t = pipe_high_pic_b + GAP_PIPE;

endmodule 