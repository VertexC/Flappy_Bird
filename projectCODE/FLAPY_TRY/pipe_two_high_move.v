`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:55:17 01/04/2017 
// Design Name: 
// Module Name:    pipe_one_high_move 
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
module pipe_two_high_move(
	input wire reset,
	input wire system_clk,
	input wire game_clk,
	input wire [1:0]veciloty,
	input wire [9:0]pixel_x,
	input wire [9:0]pixel_y,
	input wire [9:0]pipe_pic_one_l,
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

clkdiv clk3(.clk(system_clk),.rst(reset),.clkdiv(clkdiv));
assign refr_tick = clkdiv[20];

wire [8:0] P_y;
reg [8:0] random;
wire pipe_change;

assign pipe_change = (pipe_pic_l_temp + EVERYLINE_PIPE <= MIN_X)? 1'b1:1'b0;
Random rand(.clk(system_clk),.rst(reset), .init(1'b0), .P_y(P_y));//produce random y
//random the heigh of pipe in certain range
always @ (posedge pipe_change) begin
   if((P_y <= 280) & (P_y >= 180))
      random <= P_y;
   else random <= 205;
end

//need some module to make rand into a number in certain range
initial begin 
        pipe_pic_l_temp <= 280;
		  pipe_pic_b_temp <= 205;
		  end

always @(posedge game_clk or posedge reset) begin
	if (reset) begin
		pipe_pic_l_temp <= 280;
      pipe_pic_b_temp <= 205;
	end
	else if(pipe_pic_l_temp + EVERYLINE_PIPE <= MIN_X) begin
		pipe_pic_l_temp <= MAX_X;
		pipe_pic_b_temp <= random;//P_y is not valid yet
	end
	else begin
		pipe_pic_l_temp <= pipe_pic_l_next;
	end
end

always @(posedge refr_tick) begin
	pipe_pic_l_next = pipe_pic_l_temp;
	begin
		pipe_pic_l_next = pipe_pic_l_temp - veciloty;//move to left
	end
end

assign pipe_pic_l = pipe_pic_l_temp;
assign pipe_pic_r = pipe_pic_l_temp + EVERYLINE_PIPE;
assign pipe_pic_b = pipe_pic_b_temp;
assign pipe_pic_t = MIN_Y;

endmodule 
