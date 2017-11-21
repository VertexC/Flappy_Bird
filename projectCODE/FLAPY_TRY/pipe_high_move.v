`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:52:22 01/04/2017 
// Design Name: 
// Module Name:    pipe_high_move 
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
module pipe_high_move(
	input wire reset,
	input wire clk,
	input wire [9:0]pixel_x,
	input wire [9:0]pixel_y,
	output wire [9:0]pipe_pic_l,
	output wire [9:0]pipe_pic_r,
	output wire [9:0]pipe_pic_t,
	output wire [9:0]pipe_pic_b
	);
localparam EVERYLINE_PIPE = 41;
localparam HEIGHT_PIPE = 253;
localparam MAX_X = 320;
localparam MIN_X = 57;
localparam MIN_Y = 45;
reg [8:0] pipe_pic_l_temp, pipe_pic_b_temp;
reg [8:0] pipe_pic_l_next, pipe_pic_b_next;
wire [31:0] clkdiv;
wire refr_tick;

clkdiv clk3(.clk(clk),.rst(reset),.clkdiv(clkdiv));
assign refr_tick = clkdiv[18];

Random rand(clk,rst, init, P_y);//produce random y
//need some module to make rand into a number in certain range
//range 100 - 400

wire [31:0] clkdiv;
clkdiv clk4(.clk(clk),.rst(reset),.clkdiv(clkdiv));
assign refr_tick = clkdiv[18];

always @(posedge clk or posedge rst) begin
	if (rst) begin
		pipe_pic_l_temp <= 150;
        pipe_pic_b_temp <= 205;
	end
	else if(pipe_pic_l + EVERYLINE_PIPE <= MIN_X ) begin
		pipe_pic_l_temp <= MAX_X - EVERYLINE_PIPE;
		pipe_pic_b <= 260;//P_y is not valid yet
	end
	else begin
		pipe_pic_l_temp <= pipe_pic_l_next;
	end
end

always @(posedge refr_tick) begin
	pipe_pic_l_next = pipe_pic_l_temp;
	begin
		pipe_pic_l_next = pipe_pic_l_temp - PIPE_V;//move to left
	end
end

assign pipe_pic_l = pipe_pic_l_temp;
assign pipe_pic_r = pipe_pic_l_temp + EVERYLINE_PIPE;
assign pipe_pic_b = pipe_pic_b_temp;
assign pipe_pic_t = MIN_Y;

endmodule 
