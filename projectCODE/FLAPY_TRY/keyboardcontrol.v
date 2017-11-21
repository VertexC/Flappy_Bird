`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:01:52 01/01/2017 
// Design Name: 
// Module Name:    hammerpos 
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
module keyboardcontrol(
     input clk_25,clk,reset,ps2Clk,ps2Dat,
     input btn,
	  input sw,
	  output reg btnup,
	  output reg help,
	  output reg pause,
	  output reg [1:0] veciloty
    );

wire [7:0]data,data2;
wire ps2Int;
wire p;
wire h;
PS2Read Keyboard(.PS2C(ps2Clk), .PS2D(ps2Dat),.clk_25(clk),
	.data(data),.data2(data2));// the input of keyboard

initial begin
veciloty = 2;
end

//jump if space press
always @(posedge clk_25)begin

          if( btn == 1 || (data == 8'h29 && data2!=8'hF0))//keySpace
		      btnup <= 1;
		  else if( btn == 0)
		      btnup <= 0;	  
end

//speed up if A press,speed down if D press

always @(posedge clk_25)begin

          if( (data == 8'h1C && data2==8'h1C) && (veciloty <= 2))//keyA
		      veciloty <= veciloty + 1;
		  else if( (data == 8'h23 && data2==8'h23) && (veciloty >= 2))//keyD
		      veciloty <= veciloty - 1;	  
end

//always @(posedge clk_25)begin
         //if(sw == 0)
			   //pause <= 1;
			//else if(sw == 1)
			   //pause <= 0;
//end
//pause if P press
assign p = ((data == 8'h4D) && (data2 == 8'h4d));//keyP
always @(posedge (p))begin
       pause <= ~pause;
end

//help if H press
assign h = ((data == 8'h33) && (data2 == 8'h33));//keyH
always @(posedge (h))begin
       help <= ~help;
end

endmodule
