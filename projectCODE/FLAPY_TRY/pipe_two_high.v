`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:48:18 01/04/2017 
// Design Name: 
// Module Name:    pipe_one_high 
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
module pipe_two_high(
	input wire system_clk,
	input wire game_clk,
	input wire reset,
	input wire [1:0] veciloty,
	input wire [9:0] pixel_x,
	input wire [9:0] pixel_y,
	//input wire [9:0] pipe_pic_one_l,
	output wire [9:0] pipe_pic_l,
	output wire [9:0] pipe_pic_r,
	output wire [9:0] pipe_pic_t,
	output wire [9:0] pipe_pic_b,
	output wire [11:0]rgb
);

//to move the pipe_two_high
pipe_two_high_move move2(
    //input
	.system_clk(system_clk),.game_clk(game_clk),.reset(reset),.veciloty(veciloty),
	.pixel_x(pixel_x),
	.pixel_y(pixel_y),
	.pipe_pic_one_l(pipe_pic_one_l),
	//output
	.pipe_pic_r(pipe_pic_r),.pipe_pic_l(pipe_pic_l),
	.pipe_pic_t(pipe_pic_t),.pipe_pic_b(pipe_pic_b));

localparam EVERYLINE_PIPE = 41;
localparam HEIGHT_PIPE = 253;
localparam GAP_PIPE = 45;
wire [13:0] position_PIPE;

assign position_PIPE = (pixel_x - pipe_pic_l) + (EVERYLINE_PIPE) * (pipe_pic_b - pixel_y);

wire [11:0] rgb_temp_pipe;

pipe2_high PIPE_2H(
	.clka(system_clk),
	.addra(position_PIPE),
	.douta(rgb_temp_pipe));

assign rgb = rgb_temp_pipe;

endmodule 
