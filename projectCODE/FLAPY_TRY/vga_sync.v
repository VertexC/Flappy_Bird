`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:02:01 12/29/2016 
// Design Name: 
// Module Name:    vga_sync 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//             VGA synchronization circuit
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga_sync(
    input wire clk, reset,
	 output wire hsync, vsync, video_on, p_tick,
	 output wire [9:0] pixel_x, pixel_y
    );
	 
//reg [1:0] clkdiv;
//clkdiv m1(clk,clkdiv[1:0]);
// c o n s t a n t d e c l a r a t i o n
// VGA 640-by-480 sync parameters

localparam HD = 640; // h o r i z o n t a l d i s p l a y a r e a
localparam HF = 48 ; // h . f r o n t ( l e f t ) border
localparam HB = 16 ; // h . back ( r i g h t ) border
localparam HR = 96 ; // h . r e t r a c e
localparam VD = 480; // v e r t i c a l d i s p l a y a r e a
localparam VF = 10; // v . f r o n t ( t o p ) border
localparam VB = 33; // v . back ( b o t t o m ) b o r d e r
localparam VR = 2; // v . r e t r a c e


	 
reg mod2_reg;
wire mod2_next ;
// sync c o u n t e r s
reg [9:0] h_count_reg , h_count_next;
reg [9:0] v_count_reg , v_count_next ;
reg v_sync_reg , h_sync_reg ;
wire v_sync_next , h_sync_next ;
// s t a t u s s i g n a l
wire h_end , v_end , pixel_tick;

// body
// r e g i s t e r s


always @ ( posedge clk , posedge reset)
if (reset)
begin
mod2_reg <=1'b0;
//mod2_reg <= l'b0;
v_count_reg <= 0;
h_count_reg <= 0 ;
v_sync_reg <= 1'b0;
//v_sync_reg <= l'b0;
h_sync_reg <= 1'b0;
//h_sync_reg <= l'b0;
end
else
begin
mod2_reg <= mod2_next ;
v_count_reg <= v_count_next;
h_count_reg <= h_count_next;
v_sync_reg <= v_sync_next ;
h_sync_reg <= h_sync_next ;
end
assign mod2_next = ~mod2_reg;
assign  pixel_tick = mod2_reg;


// s t a t u s s i g n a l s
// end o f h o r i z o n t a l c o u n t e r ( 7 9 9 )
assign h_end = (h_count_reg==(HD+HF+HB+HR-1)) ;
// end o f v e r t i c a l c o u n t e r ( 5 2 4 )
assign v_end = (v_count_reg==(VD+VF+VB+VR-1)) ;

// n e x t _ s t a t e l o g i c o f mod_800 h o r i z o n t a l s y n c c o u n t e r
always @*
if (pixel_tick) // 25 MHz p u l s e
if (h_end)
h_count_next = 0 ;
else
h_count_next = h_count_reg + 1;
else
h_count_next = h_count_reg;

// n e x t _ s t a t e l o g i c o f mod_525 v e r t i c a l s y n c c o u n t e r
always @*
if (pixel_tick & h_end)
if (v_end)
v_count_next = 0;
else
v_count_next = v_count_reg + 1;
else
v_count_next = v_count_reg;

// h o r i z o n t a l and v e r t i c a l s y n c , b u f f e r e d t o a v o i d g l i t c h
// h_svnc_next a s s e r t e d between 656 and 751
assign h_sync_next = (h_count_reg>=(HD+HB) &&
h_count_reg<=(HD+HB+HR-1));
 // vh_sync_next a s s e r t e d between 490 and 491
assign v_sync_next = (v_count_reg>=(VD+VB) &&
v_count_reg<=(VD+VB+VR-1));
// v i d e o on/off
assign video_on = (h_count_reg<HD) && (v_count_reg<VD);

// output
assign hsync = h_sync_reg;
assign vsync = v_sync_reg;
assign pixel_x = h_count_reg;
assign pixel_y = v_count_reg;
assign p_tick = pixel_tick;
endmodule
   
