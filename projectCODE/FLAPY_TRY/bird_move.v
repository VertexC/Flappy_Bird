`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:25:08 01/04/2017 
// Design Name: 
// Module Name:    bird_move 
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

module bird_move(
	input wire rst,
	input wire game_clk,
	input wire system_clk,
   input wire btnup,	 
	output wire [9:0] bird_pic_t,
	output wire [9:0] bird_pic_b
    );

//boundary of the interface
localparam MIN_Y = 45;
localparam MAX_Y = 426;
localparam BIRD_V = 1;
localparam BIRD_L = 70;
localparam HEIGHT_BIRD = 19;

reg[9:0] bird_pic_t_temp, bird_pic_t_next;
initial bird_pic_t_temp = 235; 

wire [31:0] clkdiv;
wire refr_tick;

clkdiv clk3(.clk(system_clk),.rst(rst),.clkdiv(clkdiv));
assign refr_tick = clkdiv[18];

//move the bird
always @ (posedge game_clk or posedge rst)
   if (rst) begin
   	bird_pic_t_temp <= 235;
   end
   else begin
   	bird_pic_t_temp <= bird_pic_t_next;
   end

always @(posedge refr_tick)
begin
	bird_pic_t_next = bird_pic_t_temp;
	begin
	   if((btnup) & (bird_pic_t > BIRD_V + MIN_Y))
	     bird_pic_t_next = bird_pic_t_temp - BIRD_V;//move up
	   else if ((~btnup) & (bird_pic_b < MAX_Y - 1 - BIRD_V))
	   	 bird_pic_t_next = bird_pic_t_temp + BIRD_V;//move down
	end
end

assign bird_pic_t = bird_pic_t_temp;
assign bird_pic_b = bird_pic_t + HEIGHT_BIRD - 1;


endmodule

