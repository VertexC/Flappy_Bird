`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:23 01/02/2017 
// Design Name: 
// Module Name:    Segment 
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
module Segment(
     input wire [3:0] dat,
	  input clk,
	  output reg [7:0] seg
    );//segment module
reg [3:0] data;
always@(posedge clk) begin// segement display according to number
    data<=dat;
    if(data==0)begin
	    seg<=8'h00000011;
	 end
	 else if(data==1) seg<=8'b10011111;
	 else if(data==2) seg<=8'b00100101;
	 else if(data==3) seg<=8'b00001101;
	 else if(data==4) seg<=8'b10011001;
	 else if(data==5) seg<=8'b01001001;
	 else if(data==6) seg<=8'b01000001;
	 else if(data==7) seg<=8'b00011111;
	 else if(data==8) seg<=8'b00000001;
	 else if(data==9) seg<=8'b00001001;
	 else if(data==10)seg<=8'b00010001;
	 else if(data==11)seg<=8'b11000001;
	 else if(data==12)seg<=8'b01100011;
	 else if(data==13)seg<=8'b10000101;
	 else if(data==14)seg<=8'b01100001;
	 else if(data==15)seg<=8'b01110001;
end
endmodule
