`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:43:43 01/02/2017 
// Design Name: 
// Module Name:    NPC_Bird 
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
//
//Bug1£ºthe bird_pic_t should be const in here, it should be another module as <move> to return the varible 
//
//
//
//
module NPC_Bird(
	input wire reset,
	input wire system_clk,
	input wire game_clk,
	input wire [9:0]pixel_x,
	input wire [9:0]pixel_y,
	input wire btnup,
	input wire status,
	input wire pause,
	output wire [11:0] rgb_bird,
	output wire [9:0] bird_pic_l,
	output wire [9:0] bird_pic_r,
	output wire [9:0] bird_pic_t,
	output wire [9:0] bird_pic_b
);


wire [31:0] clkdiv;
//wire refr_tick;
clkdiv clk2(.clk(system_clk),.rst(reset),.clkdiv(clkdiv));
//assign refr_tick = clkdiv[18];
//to get the current position of bird and move the bird
bird_move move0(.game_clk(game_clk),.system_clk(system_clk),.rst(reset),.btnup(btnup),.bird_pic_t(bird_pic_t),.bird_pic_b(bird_pic_b));



//localparam MAX_Y = 426;
//localparam of bird
localparam EVERYLINE_BIRD = 27;
localparam HEIGHT_BIRD = 19;
localparam BIRD_L = 80;
wire [9:0] position_BIRD;

assign position_BIRD = (pixel_x - bird_pic_l) + (EVERYLINE_BIRD) * (HEIGHT_BIRD - 1 - pixel_y + bird_pic_t);

assign bird_pic_l = BIRD_L;
assign bird_pic_r = BIRD_L + EVERYLINE_BIRD;

// three state of birds
wire[11:0] rgb_temp_bird_up; 
wire[11:0] rgb_temp_bird_down;
wire[11:0] rgb_temp_bird_keep;

bird_fly_up bird1(
	.clka(system_clk),
	.addra(position_BIRD),
	.douta(rgb_temp_bird_up));

bird_fly_down bird2(
	.clka(system_clk),
	.addra(position_BIRD),
	.douta(rgb_temp_bird_down));

bird_fly_keep bird3( //not used yet
	.clka(system_clk),
	.addra(position_BIRD),
	.douta(rgb_temp_bird_keep));


reg [11:0] RGB_BIRD;


initial RGB_BIRD = 12'b0000_0000_0001;
//keep if gameover 
//up if flyup
//down if drop
always @ (posedge system_clk)
begin
   if(status)
	   RGB_BIRD <= rgb_temp_bird_keep;
	else if(btnup)//bird fly
	   RGB_BIRD <= rgb_temp_bird_up;
	else if(~btnup)
	   RGB_BIRD <= rgb_temp_bird_down;
end

assign rgb_bird = RGB_BIRD;


endmodule
