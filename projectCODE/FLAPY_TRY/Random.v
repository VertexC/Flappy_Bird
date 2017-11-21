`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:00:30 12/28/2016 
// Design Name: 
// Module Name:    Random 
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
module Random(clk, rst, init, P_y);
	input wire clk; 
	input wire rst;            // prevrent locking-up
	input wire init;           
	output reg [8:0] P_y;
	 
	 always@(posedge clk) 
	 begin
		if(rst)
			P_y <= 205;
		else if(init)
			P_y <= ~(9'b0);      // to load the initial value
		else begin
			P_y[0] <= P_y[8];             //1001110001
			P_y[1] <= P_y[0];
			P_y[2] <= P_y[1];
			P_y[3] <= P_y[2];
			P_y[4] <= P_y[3] ^ P_y[8];
			P_y[5] <= P_y[4] ^ P_y[8];
			P_y[6] <= P_y[5] ^ P_y[8];
			P_y[7] <= P_y[6];
			P_y[8] <= P_y[7];
		end
	 end 

endmodule
