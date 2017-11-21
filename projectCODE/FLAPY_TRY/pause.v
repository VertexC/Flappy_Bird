`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:13:58 01/05/2017 
// Design Name: 
// Module Name:    pause 
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
module pause2(
    input wire sw,
	 output wire pause
    );
	 reg p;
	 // puase if sw is 0
	 always @(*) begin
	    if(sw == 0)
		   p <= 1'b1;
		 else 
		   p <= 1'b0;
	 end
	 assign  pause = p;
endmodule
