`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:14:11 12/29/2016 
// Design Name: 
// Module Name:    VGA 
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
module VGA(Dis_clk, rst, hsync, vsync, red, green, blue);
	input wire Dis_clk;			//25MHz
	input wire rst;			//asynchronous reset
	output wire hsync;		//horizontal sync out
	output wire vsync;		//vertical sync out
	output reg [3:0] red;	//red vga output
	output reg [3:0] green; //green vga output
	output reg [3:0] blue;	//blue vga output
	

// video structure constants
	localparam HD = 640; // horizontal display area
	localparam HF = 48 ; // h. front (left) border 
	localparam HB = 16 ; // h. back (right) border 
	localparam HR = 96 ; // h. retrace
	localparam VD = 480; // vertical display area
	localparam VF = 10; // v . front (top) border 
	localparam VB = 33; // v. back (bottom) border 
	localparam VR = 2; // v . retrace

// registers for storing the horizontal & vertical counters
	reg [9:0] hc;
	reg [9:0] vc;
	wire video_on;
	
always @(posedge Dis_clk or posedge rst)
begin
	// reset 
	if (rst == 1'b1)
	begin
		hc <= 10'b0;
		vc <= 10'b0;
	end else if (hc == HF+HD+HB+HR - 1)
	        begin
				hc <= 10'b0;
				if (vc < VF+VD+VB+VR - 1)
					vc <= vc + 10'b1;
				else vc <= 0;
			end	
		  else hc <= hc + 10'b1;
end

	assign video_on = ((hc >= HR + HF - 1) && (hc < HF+HD+HR - 1) && 
	(vc >= VR + VF - 1) && (vc < VF+VD+VR - 1));

// generate sync
	assign hsync = (hc >= HR);
	assign vsync = (vc >= VR);

	always @(*)
	begin
	if (video_on)
	begin
		// grass
		if (vc >= 300)
		begin
			red = 4'b0000;
			green = 4'b1111;
			blue = 4'b0000;
		end
		// background
		else
		begin
			red = 4'b0000;
			green = 4'b1111;
			blue = 4'b1111;
		end
	end
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end

endmodule