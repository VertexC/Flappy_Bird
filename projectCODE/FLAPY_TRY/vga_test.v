`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:27:28 12/29/2016 
// Design Name: 
// Module Name:    vga_test 
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
module vga_test(
    input wire clk,reset,
	 input wire [2:0] sw,
	 output wire hsync,vsync,
	 output wire [2:0] rgb
    );
	 
	 //signal declaration
	 //reg [3:0] r_reg;
	//reg [3:0] g_reg;
	 //reg [3:0] b_reg;
	 reg [2:0] rgb_reg;
	 wire [31:0] clk_div;
	 wire video_on;
	 
	 //instantiate vga sync circuit
	 clkdiv clock(.clk(clk),.rst(reset),.clkdiv(clk_div));
	 vga_sync vsync_unit
	 (.clk(clk_div[1]),.reset(reset),.hsync(hsync),.vsync(vsync),
	 .video_on(video_on),.p_tick(),.pixel_x(),.pixel_y());
	 //rgb buffer
	 
	 always @(posedge clk, posedge reset)
	    if (reset)
		 begin
		   rgb_reg <= 0;
		    //r_reg <= 0;
			 //g_reg <= 0;
			 //b_reg <= 0;
		 end
	    else
       begin		 
		    //r_reg <= sw ;
			 //g_reg <= sw ;
			 //b_reg <= sw ;
			 rgb_reg <= sw;
		 end
	 //output
	 
	 //assign r = (video_on) ? r_reg : 4'b0101;
	 //assign g = (video_on) ? g_reg : 4'b0101;
	 //assign b = (video_on) ? b_reg : 4'b0101;
	 assign rgb = (video_on) ? rgb_reg : 3'b000;
	 
endmodule
