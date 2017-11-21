// top with two pipe

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:29:41 01/02/2017 
// Design Name: 
// Module Name:    bird_control 
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
module bird_control(
   input wire ps2Clk,
	input wire ps2Dat,
	input wire system_clk,
  
	input wire reset,
	input wire btn,
	input wire sw,
   //output wire buzzer, // as music 	
	output wire [3:0] AN,
	output wire [7:0] Segment,
	output wire hsync,vsync,
	output wire [11:0] rgb
    );
	 
wire btnup;
wire status;// 1 for gameover
wire pause2;// pause form N4 board
wire pause1;// pause form keyborad
wire pause;
wire game_clk;
wire help;//the signal of user ask 

reg clk;
wire [1:0] veciloty;//the veciloty of pipe
wire [31:0] clk_div;

pause2 p0(.sw(sw),.pause(pause1));//deal with the swtich of pause pf N4 board


assign game_clk = (system_clk | pause | status);

// to judge whether the bird crashes into the pipe
assign status  =(  ( (bird_pic_l >= pipe_high_pic_l)
                   & (bird_pic_r <= pipe_high_pic_r)
                   & (bird_pic_t >= pipe_high_pic_t)
                   & (bird_pic_b <= pipe_high_pic_b) ) |
						 
	                ( (bird_pic_l >= pipe_low_pic_l)
                   & (bird_pic_r <= pipe_low_pic_r)
                   & (bird_pic_t >= pipe_low_pic_t)
                   & (bird_pic_b <= pipe_low_pic_b) )  |
						 
	                ( (bird_pic_l >= ypipe_high_pic_l)
                   & (bird_pic_r <= ypipe_high_pic_r)
                   & (bird_pic_t >= ypipe_high_pic_t)
                   & (bird_pic_b <= ypipe_high_pic_b) ) |
	                ( 
						   (bird_pic_l >= ypipe_low_pic_l)
                   & (bird_pic_r <= ypipe_low_pic_r)
                   & (bird_pic_t >= ypipe_low_pic_t)
                   & (bird_pic_b <= ypipe_low_pic_b) )
				);		
				

 
clkdiv clk1(.clk(system_clk),.rst(reset),.clkdiv(clk_div));


//deal with the key press from keyborad and N4 board
keyboardcontrol KeyBoardControl(.clk_25(clk_div[2]),.clk(system_clk),.reset(reset),.ps2Clk(ps2Clk),.ps2Dat(ps2Dat),
     .sw(sw),
     .btn(btn),
	  .pause(pause2),
	  .btnup(btnup),
	  .help(help),
	  .veciloty(veciloty)
    );
	 
assign pause = (pause1 | pause2);

reg [11:0]rgb_reg;

wire video_on;
//the rgb of ojects
wire [11:0]rgb_bird;
wire [11:0]rgb_pipe_low;
wire [11:0]rgb_pipe_high;

wire [11:0]rgb_ypipe_low;
wire [11:0]rgb_ypipe_high;
wire [11:0]rgb_day_background;
wire [11:0]rgb_night_background;
reg [11:0] rgb_background;
wire [11:0]rgb_gameover;
wire [11:0]rgb_logo;
wire [11:0]rgb_pause;
wire [11:0]rgb_press_help;
wire [11:0]rgb_help;
// the scan coordinate
wire [9:0] pixel_x;
wire [9:0] pixel_y;
// the boundary of the pictures
wire [9:0] bird_pic_l,bird_pic_r,bird_pic_t,bird_pic_b;
wire [9:0] pipe_high_pic_l,pipe_high_pic_r,pipe_high_pic_t,pipe_high_pic_b;
wire [9:0] pipe_low_pic_l,pipe_low_pic_r,pipe_low_pic_t,pipe_low_pic_b;

wire [9:0] ypipe_high_pic_l,ypipe_high_pic_r,ypipe_high_pic_t,ypipe_high_pic_b;
wire [9:0] ypipe_low_pic_l,ypipe_low_pic_r,ypipe_low_pic_t,ypipe_low_pic_b;

wire [15:0] score; 
// to count the socre and display
Disp_Score DispScore(
	.system_clk(system_clk),
	.game_clk(game_clk),
	.reset(reset),
	.bird_pic_l(bird_pic_l),
	.bird_pic_r(bird_pic_r),
	.bird_pic_t(bird_pic_t),
	.bird_pic_b(bird_pic_b),
	.pipe_high_pic_r(pipe_high_pic_r),
	.pipe_high_pic_l(pipe_high_pic_l),
	.pipe_low_pic_t(pipe_low_pic_t),
	.pipe_high_pic_b(pipe_high_pic_b),
	.ypipe_high_pic_r(ypipe_high_pic_r),
	.ypipe_high_pic_l(ypipe_high_pic_l),
	.ypipe_low_pic_t(ypipe_low_pic_t),
	.ypipe_high_pic_b(ypipe_high_pic_b),
	.AN(AN),
	.Segment(Segment),
	//output wire Buzzer,
	.score(score)
    );

//to control the bird 
NPC_Bird bird_one(
	//input
	.reset(reset),.game_clk(game_clk),.system_clk(system_clk),.pixel_x(pixel_x),.pixel_y(pixel_y),.pause(pause),
	.btnup(btnup),.status(status),
	//output
	.bird_pic_l(bird_pic_l),.bird_pic_r(bird_pic_r),.bird_pic_t(bird_pic_t),.bird_pic_b(bird_pic_b),
	.rgb_bird(rgb_bird)
);

//to move the pipe_one_high
pipe_one_high pipe_one_H(
	.game_clk(game_clk),
	.system_clk(system_clk),
	.reset(reset),
	.veciloty(veciloty),
	.pixel_x(pixel_x),
	.pixel_y(pixel_y),
	.pipe_pic_l(pipe_high_pic_l),
	.pipe_pic_r(pipe_high_pic_r),
	.pipe_pic_t(pipe_high_pic_t),
	.pipe_pic_b(pipe_high_pic_b),
	.rgb(rgb_pipe_high)
);

//to move the pipe_one_low
pipe_one_low pip_one_L(
	.game_clk(game_clk),
	.system_clk(system_clk),
	.reset(reset),
	.pixel_x(pixel_x),
	.pixel_y(pixel_y),
	.pipe_high_pic_l(pipe_high_pic_l),
	.pipe_high_pic_r(pipe_high_pic_r),
	.pipe_high_pic_t(pipe_high_pic_t),
	.pipe_high_pic_b(pipe_high_pic_b),
	.pipe_pic_l(pipe_low_pic_l),
	.pipe_pic_r(pipe_low_pic_r),
	.pipe_pic_t(pipe_low_pic_t),
	.pipe_pic_b(pipe_low_pic_b),
   .rgb(rgb_pipe_low)
);

// the pixel-in signal
wire temp_pipe_high;//pipe hign
wire temp_pipe_low;//pipe low

assign temp_pipe_high = ((pixel_x >= pipe_high_pic_l) & (pixel_x <= pipe_high_pic_r)
                    & (pixel_y >= pipe_high_pic_t) & (pixel_y <= pipe_high_pic_b)); 

assign temp_pipe_low = ((pixel_x >= pipe_low_pic_l) & (pixel_x <= pipe_low_pic_r)
                    & (pixel_y >= pipe_low_pic_t) & (pixel_y <= pipe_low_pic_b)); 
						  
// to move the pipe_two_high
pipe_two_high pipe_two_H(
	.game_clk(game_clk),
	.system_clk(system_clk),
	.reset(reset),
	.veciloty(veciloty),
	.pixel_x(pixel_x),
	.pixel_y(pixel_y),
	//.pipe_pic_one_l(pipe_high_pic_l),
	.pipe_pic_l(ypipe_high_pic_l),
	.pipe_pic_r(ypipe_high_pic_r),
	.pipe_pic_t(ypipe_high_pic_t),
	.pipe_pic_b(ypipe_high_pic_b),
	.rgb(rgb_ypipe_high)
);


// to move the pipe_two_low
pipe_two_low pip_two_L(
	.game_clk(game_clk),
	.system_clk(system_clk),
	.reset(reset),
	.pixel_x(pixel_x),
	.pixel_y(pixel_y),
	.pipe_high_pic_l(ypipe_high_pic_l),
	.pipe_high_pic_r(ypipe_high_pic_r),
	.pipe_high_pic_t(ypipe_high_pic_t),
	.pipe_high_pic_b(ypipe_high_pic_b),
	.pipe_pic_l(ypipe_low_pic_l),
	.pipe_pic_r(ypipe_low_pic_r),
	.pipe_pic_t(ypipe_low_pic_t),
	.pipe_pic_b(ypipe_low_pic_b),
   .rgb(rgb_ypipe_low)
);
// the pixel-in signal
wire temp_ypipe_high;//pipe hihg
wire temp_ypipe_low;//pipe low

assign temp_ypipe_high = ((pixel_x >= ypipe_high_pic_l) & (pixel_x <= ypipe_high_pic_r)
                    & (pixel_y >= ypipe_high_pic_t) & (pixel_y <= ypipe_high_pic_b)); 

assign temp_ypipe_low = ((pixel_x >= ypipe_low_pic_l) & (pixel_x <= ypipe_low_pic_r)
                    & (pixel_y >= ypipe_low_pic_t) & (pixel_y <= ypipe_low_pic_b)); 


//the pixel-in signal
wire temp_bgp;//backgroudpicture
wire temp_bird;//bird


wire temp_gameover;//gameover
wire temp_logo;//logo
wire temp_pause;//pause signal
wire temp_press_help;// "press for help" promotion
wire temp_help;// help information

//localparam of BGP
localparam EVERYLINE_BGP = 263;
localparam HEIGHT_BGP = 381;
localparam BGP_L = 57;
localparam BGP_T = 45;

//backgroudpictrue in IP
wire [16:0] position_BGP;

assign position_BGP = BGP_L - pixel_x + (EVERYLINE_BGP) * (BGP_T - pixel_y + HEIGHT_BGP - 1);

BGP day_background(
	.clka(system_clk),
	.ena(1'b1),
	.addra(position_BGP),
	.douta(rgb_day_background)
	);
	
n_background night_background(
	.clka(system_clk),
	.addra(position_BGP),
	.douta(rgb_night_background)
	);
	
//change the background every time the count comes to intergle multiple of four
always @(*) begin
   if(score[4] == 1)
	  rgb_background <= rgb_night_background;
	else rgb_background <= rgb_day_background;
end



///localparam of logo
localparam LOGO_L = 400;
localparam HEIGHT_LOGO = 41;
localparam EVERYLINE_LOGO = 149;
localparam LOGO_T = 90;
wire [12:0] position_LOGO;

assign position_LOGO = - LOGO_L + pixel_x + (EVERYLINE_LOGO) * (LOGO_T - pixel_y + HEIGHT_LOGO - 1);

logo LOGO(
	.clka(system_clk),
	.addra(position_LOGO),
	.douta(rgb_logo)
	);
	
///localparam of press_help
localparam PRESS_HELP_L = 380;
localparam HEIGHT_PRESS_HELP = 39;
localparam EVERYLINE_PRESS_HELP = 226;
localparam PRESS_HELP_T = 150;
wire [13:0] position_PRESS_HELP;

assign position_PRESS_HELP = - PRESS_HELP_L + pixel_x + (EVERYLINE_PRESS_HELP) * (PRESS_HELP_T - pixel_y + HEIGHT_PRESS_HELP - 1);

press_help PressHelp(
	.clka(system_clk),
	.addra(position_PRESS_HELP),
	.douta(rgb_press_help)
	);

///localparam of help information
localparam HELP_L = 360;
localparam HEIGHT_HELP = 125;
localparam EVERYLINE_HELP = 280;
localparam HELP_T = 200;
wire [15:0] position_HELP;

assign position_HELP = - HELP_L + pixel_x + (EVERYLINE_HELP) * (HELP_T - pixel_y + HEIGHT_HELP - 1);

help Help(
	.clka(system_clk),
	.addra(position_HELP),
	.douta(rgb_help)
	);

///localparam of pause signal
localparam PAUSE_L = 136;
localparam HEIGHT_PAUSE = 58;
localparam EVERYLINE_PAUSE = 104;
localparam PAUSE_T = 220;
wire [12:0] position_PAUSE;

assign position_PAUSE =  - PAUSE_L + pixel_x + (EVERYLINE_PAUSE) * (PAUSE_T - pixel_y + HEIGHT_PAUSE - 1);

pause PAUSE0(
	.clka(system_clk),
	.addra(position_PAUSE),
	.douta(rgb_pause)
	);


//localparam of gameover signal
localparam EVERYLINE_GOVER = 158;
localparam HEIGHT_GOVER = 37;
localparam GOVER_L = 109;
localparam GOVER_T = 242;
wire [12:0] position_gameover;

assign position_gameover = pixel_x - GOVER_L  + (EVERYLINE_GOVER) * (GOVER_T - pixel_y + HEIGHT_GOVER - 1);

gameover game_over(
	.clka(system_clk),
	.addra(position_gameover),
	.douta(rgb_gameover)
	);

//vga can module
vga_sync vsync_unit(.clk(clk_div[0]),.reset(reset),
	.hsync(hsync),.vsync(vsync),.video_on(video_on),.pixel_x(pixel_x),.pixel_y(pixel_y));//proved work 


//to judge whether the object should be displayed
assign temp_bgp = ((pixel_x >= BGP_L) & (pixel_x <= BGP_L + EVERYLINE_BGP)
                    & (pixel_y >= BGP_T) & (pixel_y <= BGP_T + HEIGHT_BGP));

assign temp_bird = ((pixel_x >= bird_pic_l) & (pixel_x <= bird_pic_r)
	                 & (pixel_y >= bird_pic_t) & (pixel_y <= bird_pic_b));



assign temp_gameover = (status &  
                  (	(pixel_x >= GOVER_L) & (pixel_x <= GOVER_L + EVERYLINE_GOVER) & (pixel_y >= GOVER_T) & (pixel_y <= GOVER_T + HEIGHT_GOVER) )
                  );

assign temp_pause = ((pause == 1) &
	                (status != 1) &
	                ((pixel_x >= PAUSE_L) & (pixel_x <= PAUSE_L + EVERYLINE_PAUSE) & (pixel_y >= PAUSE_T) & (pixel_y <= PAUSE_T + HEIGHT_PAUSE))
	                );

assign temp_logo = ((pixel_x >= LOGO_L) & (pixel_x <= LOGO_L + EVERYLINE_LOGO) 
                  & (pixel_y >= LOGO_T) & (pixel_y <= LOGO_T + HEIGHT_LOGO) ) ;

assign temp_press_help = ((~help) & (pixel_x >= PRESS_HELP_L) & (pixel_x <= PRESS_HELP_L + EVERYLINE_PRESS_HELP) 
                  & (pixel_y >= PRESS_HELP_T) & (pixel_y <= PRESS_HELP_T + HEIGHT_PRESS_HELP) ) ;

assign temp_help = ((help) & (pixel_x >= HELP_L) & (pixel_x <= HELP_L + EVERYLINE_HELP) 
                  & (pixel_y >= HELP_T) & (pixel_y <= HELP_T + HEIGHT_HELP) ) ;

//to get the rgb of objects
always @ (posedge system_clk)//if clk_div[0] change into clk, no display of bird

  begin
  	rgb_reg <= 12'b0000_0000_0100;

//to display the logo
    if(temp_logo) begin
        if(rgb_logo != 0)
    	  rgb_reg <= rgb_logo;
    	else rgb_reg <= 12'b0010_0000_0000;
    end
// to display the "press for help" promotion	 
	 else if(temp_press_help) begin
        if(rgb_press_help != 0)
    	  rgb_reg <= rgb_press_help;
    	else rgb_reg <= 12'b0010_0000_0000;
    end
// to display the help information	 
	 else if(temp_help) begin
        if(rgb_help != 0)
    	  rgb_reg <= rgb_help;
    	else rgb_reg <= 12'b0010_0000_0000;
    end
// to display the gameover signal
    else if(temp_gameover)begin
	   if(rgb_gameover != 0)
    	  rgb_reg <= rgb_gameover;
	   else if(temp_pipe_high|temp_pipe_low|temp_ypipe_high|temp_ypipe_low)begin
		  if((rgb_pipe_high != 0) & temp_pipe_high)
		  rgb_reg <= rgb_pipe_high;
		  else if((temp_pipe_low != 0) & temp_pipe_low)
		  rgb_reg <= rgb_pipe_low;
		  else if((temp_ypipe_high != 0) & temp_ypipe_high)
		  rgb_reg <= rgb_ypipe_high;
		  else if((temp_ypipe_low != 0) & temp_ypipe_low)
		  rgb_reg <= rgb_ypipe_low;
		end
		else rgb_reg <= rgb_background;
	 end
// to display the pause signal
     else if(temp_pause)begin
	   if(rgb_pause != 0)
    	  rgb_reg <= rgb_pause;
	   else if(temp_pipe_high|temp_pipe_low|temp_ypipe_high|temp_ypipe_low)begin
		  if((rgb_pipe_high != 0) & temp_pipe_high)
		  rgb_reg <= rgb_pipe_high;
		  else if((temp_pipe_low != 0) & temp_pipe_low)
		  rgb_reg <= rgb_pipe_low;
		  else if((temp_ypipe_high != 0) & temp_ypipe_high)
		  rgb_reg <= rgb_ypipe_high;
		  else if((temp_ypipe_low != 0) & temp_ypipe_low)
		  rgb_reg <= rgb_ypipe_low;
		end
		else 
		  rgb_reg <= rgb_background;
    end
// to display the bird
// bird->pipe_one/pipe_two->background	 
	else if(temp_bird & temp_pipe_high) begin
  		if (rgb_bird != 0)
  		   rgb_reg <= rgb_bird;
  		else if ((rgb_bird == 0) & ( rgb_pipe_high!= 0) )
  		   rgb_reg <= rgb_pipe_high; 
  	end
	
  	else if(temp_bird & temp_pipe_low) begin
  		if (rgb_bird != 0)
  		   rgb_reg <= rgb_bird;
  		else if ((rgb_bird == 0) & ( rgb_pipe_low!= 0) )
  		   rgb_reg <= rgb_pipe_low; 
  	end

  	else if(temp_bird & temp_ypipe_high) begin
  		if (rgb_bird != 0)
  		   rgb_reg <= rgb_bird;
  		else if ((rgb_bird == 0) & ( rgb_ypipe_high!= 0) )
  		   rgb_reg <= rgb_ypipe_high; 
  	end
  	else if(temp_bird & temp_ypipe_low) begin
  		if (rgb_bird != 0)
  		   rgb_reg <= rgb_bird;
  		else if ((rgb_bird == 0) & ( rgb_ypipe_low != 0) )
  		   rgb_reg <= rgb_ypipe_low; 
  	end

  	else if(temp_bgp & temp_bird)begin
	   if((rgb_bird != 0) & temp_bird)
  	      rgb_reg <= rgb_bird;
	   else if((rgb_bird == 0) & temp_bgp)
		   rgb_reg <= rgb_background;
	end
//to display the pipe_one
	else if (temp_pipe_high & temp_bgp)begin
	   if((rgb_pipe_high != 0) & temp_pipe_high)
		   rgb_reg <= rgb_pipe_high;
		else if ((rgb_pipe_high == 0) & temp_bgp)
		   rgb_reg <= rgb_background;
	end
	else if (temp_pipe_low & temp_bgp)begin
	     if((rgb_pipe_low != 0) & temp_pipe_low)
		     rgb_reg <= rgb_pipe_low;
		  else if ((rgb_pipe_low == 0) & temp_bgp)
		     rgb_reg <= rgb_background;
   end
//to display the pipe_two
   else if (temp_ypipe_high & temp_bgp)begin
	   if((rgb_ypipe_high != 0) & temp_ypipe_high)
		   rgb_reg <= rgb_ypipe_high;
		else if ((rgb_ypipe_high == 0) & temp_bgp)
		  rgb_reg <= rgb_background;
	end
	else if (temp_ypipe_low & temp_bgp)begin
	     if((rgb_ypipe_low != 0) & temp_ypipe_low)
		     rgb_reg <= rgb_ypipe_low;
		  else if ((rgb_ypipe_low == 0) & temp_bgp)
		     rgb_reg <= rgb_background;
   end
//to display the background picture
	else if (temp_bgp)
	     rgb_reg <= rgb_background;
   else rgb_reg <= 12'b0010_0000_0000;
end

assign  rgb = (video_on)?rgb_reg:12'b0000_0010_0000;
//assign  buzzer = (btn)?1'b0:1'b1;

endmodule

