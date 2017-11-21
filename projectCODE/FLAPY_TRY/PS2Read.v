`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:47:37 11/06/2015 
// Design Name: 
// Module Name:    PS2Read 
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
module PS2Read(
   input clk_25,
   input PS2C,
   input PS2D,
   output [7:0] data,data2
   );// input of keyboard
 
   reg PS2Cf,PS2Df;
   reg [7:0] ps2c_filter, ps2d_filter;
   reg [10:0] shift1, shift2;
 
 assign data = shift1[8:1];
 assign data2=shift2[8:1];
 always@(posedge clk_25) begin
 /* if(clr==1) begin
  		ps2c_filter<=0;
   		ps2d_filter<=0;
   		PS2Cf<=1;
   		PS2Df<=1;
 	 end
  else begin*/
   		ps2c_filter[7]<=PS2C;
   		ps2c_filter[6:0]<=ps2c_filter[7:1];
   		ps2d_filter[7]<=PS2D;
   		ps2d_filter[6:0]<=ps2d_filter[7:1];
 		if(ps2c_filter==8'b1111_1111)
    			PS2Cf<=1;
   		else if(ps2c_filter==8'b0000_0000)
    			PS2Cf<=0;
   		if(ps2d_filter==8'b1111_1111)
    			PS2Df<=1;
   		else if(ps2d_filter==8'b0000_0000)
    			PS2Df<=0;
 	// end
 end
 
 always@(negedge PS2Cf) begin
 /* if(clr ==1) begin
   		shift1<=0;
   		shift2<=1;
  	end
  else begin*/
   		shift1<={PS2Df,shift1[10:1]};
  		shift2<={shift1[0],shift2[10:1]};
 	// end
 end
 
endmodule
/*module PS2Read(
	input clk, input rst, input ps2Clk, input ps2Dat,input clk_25,
	output reg [7:0] data,data2,
	output reg ps2Int
);

	reg [9:0] byteBuf;
	reg [3:0] count;
	reg [2:0] ps2ClkRecord;

	always @ (posedge clk)
	begin
		if(rst)
		begin
			count <= 0;
			ps2ClkRecord <=3'b111;                               
			ps2Int <= 0;
		end
		else
		begin
			ps2ClkRecord <= {ps2ClkRecord[1:0], ps2Clk};
			if({ps2ClkRecord, ps2Clk} == 4'b1100)//Falling edge
			begin
				if(count == 4'hA)
				begin
					if(~byteBuf[0] && ps2Dat)
					begin
						data <= byteBuf[8:1];
						ps2Int <= 1;
					end
					count <= 0;
				end
				else
				begin
					ps2Int <= 0;
					byteBuf <= {ps2Dat, byteBuf[9:1]};
					count <= count + 4'b1;
				end
			end
		end
	end
endmodule*/
