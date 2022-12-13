//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input [9:0] BoyX, BoyY, GirlX, GirlY, DrawX, DrawY, Board_y_X, Board_y_Y, Board_p_X, Board_p_Y, Box_X, Box_Y,
							  input [3:0] boy_status, girl_status,
							  input win, lose,
							  input diamond_r1, diamond_r2, diamond_r3, diamond_b1, diamond_b2, diamond_b3, diamond_b4,
							  input Clk,
                       output logic [7:0]  Red, Green, Blue );
    
    logic boy_on, girl_on, board_y_on, board_p_on, box_on, button1_on, button2_on, button3_on, win_on, lose_on;
	 logic diamond_r1_on, diamond_r2_on, diamond_r3_on, diamond_b1_on, diamond_b2_on, diamond_b3_on, diamond_b4_on;
	 logic boy_left_on, boy_right_on, boy_up_on, boy_down_on, boy_leftup_on, boy_rightup_on, boy_leftdown_on, boy_rightdown_on;
	 logic girl_left_on, girl_right_on, girl_up_on, girl_down_on, girl_leftup_on, girl_rightup_on, girl_leftdown_on, girl_rightdown_on;

    int DistX_b, DistY_b, DistX_g, DistY_g, DistX_by, DistY_by, DistX_bp, DistY_bp, DistX_box, DistY_box;
	 int DistX_b1, DistY_b1, DistX_b2, DistY_b2, DistX_b3, DistY_b3;
	 int DistX_dr1, DistY_dr1, DistX_dr2, DistY_dr2, DistX_dr3, DistY_dr3;
	 int DistX_db1, DistY_db1, DistX_db2, DistY_db2, DistX_db3, DistY_db3, DistX_db4, DistY_db4;
	 int DistX_window, DistY_window;
	 
	 logic [3:0] data_bgd;
	 logic [2:0] data_boy, data_girl, data_dr1, data_dr2, data_dr3, data_db1, data_db2, data_db3, data_db4;
	 logic [2:0] data_boy_left, data_boy_right, data_boy_up, data_boy_down, data_boy_leftup, data_boy_rightup, data_boy_leftdown, data_boy_rightdown;
	 logic [2:0] data_girl_left, data_girl_right, data_girl_up, data_girl_down, data_girl_leftup, data_girl_rightup, data_girl_leftdown, data_girl_rightdown;
	 logic data_by;
	 logic [1:0] data_box, data_b1, data_b2, data_b3, data_win, data_lose;
	 logic [16:0] pixel_bgd;
	 logic [9:0] pixel_boy, pixel_girl, pixel_boy_up, pixel_boy_down, pixel_boy_leftdown, pixel_boy_rightdown;
	 logic [9:0] pixel_girl_up, pixel_girl_down, pixel_girl_leftdown, pixel_girl_rightdown;
	 logic [7:0] pixel_by, pixel_bp, pixel_b1, pixel_b2, pixel_b3;
	 logic [8:0] pixel_box, pixel_dr1, pixel_dr2, pixel_dr3, pixel_db1, pixel_db2, pixel_db3, pixel_db4;
	 logic [10:0] pixel_boy_left, pixel_boy_right, pixel_boy_leftup, pixel_boy_rightup;
	 logic [10:0] pixel_girl_left, pixel_girl_right, pixel_girl_leftup, pixel_girl_rightup;
	 logic [11:0] pixel_window;
	 
	 assign DistX_b = DrawX - BoyX;
    assign DistY_b = DrawY - BoyY;
	 assign DistX_g = DrawX - GirlX;
    assign DistY_g = DrawY - GirlY;
	 assign DistX_by = DrawX - Board_y_X;
	 assign DistY_by = DrawY - Board_y_Y;
	 assign DistX_bp = DrawX - Board_p_X;
	 assign DistY_bp = DrawY - Board_p_Y;
	 assign DistX_box = DrawX - Box_X;
	 assign DistY_box = DrawY - Box_Y;
	 assign DistX_b1 = DrawX - 68*2;
	 assign DistY_b1 = DrawY - 163*2;
	 assign DistX_b2 = DrawX - 81*2;
	 assign DistY_b2 = DrawY - 121*2;
	 assign DistX_b3 = DrawX - 246*2;
	 assign DistY_b3 = DrawY - 87*2;
//	RED(163, 214) (54, 104) (88, 15)
//	BLUE(227, 214) (185, 115) (11, 41) (188, 33)
	 assign DistX_dr1 = DrawX - 163*2;
	 assign DistY_dr1 = DrawY - 214*2;
	 assign DistX_dr2 = DrawX - 54*2;
	 assign DistY_dr2 = DrawY - 104*2;
	 assign DistX_dr3 = DrawX - 88*2;
	 assign DistY_dr3 = DrawY - 15*2;
	 assign DistX_db1 = DrawX - 227*2;
	 assign DistY_db1 = DrawY - 214*2;
	 assign DistX_db2 = DrawX - 185*2;
	 assign DistY_db2 = DrawY - 115*2;
	 assign DistX_db3 = DrawX - 11*2;
	 assign DistY_db3 = DrawY - 41*2;
	 assign DistX_db4 = DrawX - 188*2;
	 assign DistY_db4 = DrawY - 33*2;
	 assign DistX_window = DrawX - 220;
	 assign DistY_window = DrawY - 208;

	 assign pixel_bgd = DrawY/2*320+DrawX*1/2;
	 assign pixel_window = DistY_window/2*100 + DistX_window*1/2;
	 
	 assign pixel_boy = DistY_b*20 + DistX_b;
	 assign pixel_boy_left = DistY_b*36 + DistX_b;
	 assign pixel_boy_right = DistY_b*36 + DistX_b-17;
	 assign pixel_boy_up = DistY_b*20 + DistX_b;
	 assign pixel_boy_down = (DistY_b+5)*20 + DistX_b;
	 assign pixel_boy_leftup = DistY_b*36 + DistX_b;
	 assign pixel_boy_rightup = DistY_b*36 + DistX_b-17;
	 assign pixel_boy_leftdown = DistY_b*27 + DistX_b;
	 assign pixel_boy_rightdown = DistY_b*27 + DistX_b+8;
	 
	 assign pixel_girl = DistY_g*20 + DistX_g;
	 assign pixel_girl_left = DistY_g*36 + DistX_g;
	 assign pixel_girl_right = DistY_g*36 + DistX_g-17;
	 assign pixel_girl_up = DistY_g*20 + DistX_g;
	 assign pixel_girl_down = (DistY_g+5)*20 + DistX_g;
	 assign pixel_girl_leftup = DistY_g*36 + DistX_g;
	 assign pixel_girl_rightup = DistY_g*36 + DistX_g-17;
	 assign pixel_girl_leftdown = DistY_g*27 + DistX_g;
	 assign pixel_girl_rightdown = DistY_g*27 + DistX_g+8;
	 
	 assign pixel_by = DistY_by/2*32 + DistX_by*1/2;
	 assign pixel_bp = DistY_bp/2*32 + DistX_bp*1/2;
	 assign pixel_box = DistY_box/2*18 + DistX_box*1/2;
	 assign pixel_b1 = DistY_b1*24 + DistX_b1;
	 assign pixel_b2 = DistY_b2*24 + DistX_b2;
	 assign pixel_b3 = DistY_b3*24 + DistX_b3;
	 assign pixel_dr1 = DistY_dr1*20 + DistX_dr1;
	 assign pixel_dr2 = DistY_dr2*20 + DistX_dr2;
	 assign pixel_dr3 = DistY_dr3*20 + DistX_dr3;
	 assign pixel_db1 = DistY_db1*20 + DistX_db1;
	 assign pixel_db2 = DistY_db2*20 + DistX_db2;
	 assign pixel_db3 = DistY_db3*20 + DistX_db3;
	 assign pixel_db4 = DistY_db4*20 + DistX_db4;
	 
	 
	logic [23:0] col [15:0];
	
	assign col[0] = 24'hffcc00;
	assign col[1] = 24'hff0000;
	assign col[2] = 24'hff4e00;
	assign col[3] = 24'h317e85;
	assign col[4] = 24'h48c3eb;
	assign col[5] = 24'h0;
	assign col[6] = 24'h002c00;
	assign col[7] = 24'h332e17;
	assign col[8] = 24'h5b5736;
	assign col[9] = 24'h413b1d;
	assign col[10] = 24'h585228;
	assign col[11] = 24'h6d6331;
	assign col[12] = 24'h3c3C00;
	assign col[13] = 24'h009000;
	assign col[14] = 24'h035101;
	assign col[15] = 24'h007f00;
	
	logic [23:0] col_b [7:0];
	
	assign col_b[0] = 24'hffffff;
	assign col_b[1] = 24'h0;
	assign col_b[2] = 24'h800000;
	assign col_b[3] = 24'h370d01;
	assign col_b[4] = 24'h791c02;
	assign col_b[5] = 24'hf53904;
	assign col_b[6] = 24'hffd000;
	assign col_b[7] = 24'h382e00;
	
	logic [23:0] col_g [7:0];
	assign col_g[0] = 24'hffffff;
	assign col_g[1] = 24'h0;
	assign col_g[2] = 24'h00b3ff;
	assign col_g[3] = 24'h66ffff;
	assign col_g[4] = 24'h73d5ff;
	assign col_g[5] = 24'h009de1;
	assign col_g[6] = 24'h5dceff;
	assign col_g[7] = 24'h64fbfb;
	
	logic [23:0] col_by [1:0];
	assign col_by[0] = 24'hfff800;
	assign col_by[1] = 24'hd9d9d9;
	
	logic [23:0] col_bp [1:0];
	assign col_bp[0] = 24'haf08d3;
	assign col_bp[1] = 24'hd9d9d9;
	
	logic [23:0] col_box [3:0];
	assign col_box[0] = 24'hffffff;
	assign col_box[1] = 24'h0;
	assign col_box[2] = 24'hfff800;
	assign col_box[3] = 24'hd9d9d9;
	
	logic [23:0] col_button1 [3:0];
	assign col_button1[0] = 24'hffffff;
	assign col_button1[1] = 24'h0;
	assign col_button1[2] = 24'hd9d9d9;
	assign col_button1[3] = 24'hfff800;
	
	logic [23:0] col_button2 [3:0];
	assign col_button2[0] = 24'hffffff;
	assign col_button2[1] = 24'h0;
	assign col_button2[2] = 24'haf08d3;
	assign col_button2[3] = 24'hfff800;
	
	logic [23:0] col_win [3:0];
	assign col_win[0] = 24'hffffff;
	assign col_win[1] = 24'h0;
	assign col_win[2] = 24'hfffe00;
	assign col_win[3] = 24'hffcb00;
	
	 background bgd(.pixel_addr(pixel_bgd), .Clk(Clk), .data_Out(data_bgd));
	 
	 boy boy(.pixel_addr(pixel_boy), .Clk(Clk), .data_Out(data_boy));
	 boy_left boy_l(.pixel_addr(pixel_boy_left), .Clk(Clk), .data_Out(data_boy_left));
	 boy_right boy_r(.pixel_addr(pixel_boy_right), .Clk(Clk), .data_Out(data_boy_right));
	 boy_up boy_u(.pixel_addr(pixel_boy_up), .Clk(Clk), .data_Out(data_boy_up));
	 boy_down boy_d(.pixel_addr(pixel_boy_down), .Clk(Clk), .data_Out(data_boy_down));
	 boy_leftup boy_lu(.pixel_addr(pixel_boy_leftup), .Clk(Clk), .data_Out(data_boy_leftup));
	 boy_rightup boy_ru(.pixel_addr(pixel_boy_rightup), .Clk(Clk), .data_Out(data_boy_rightup));
	 boy_leftdown boy_ld(.pixel_addr(pixel_boy_leftdown), .Clk(Clk), .data_Out(data_boy_leftdown));
	 boy_rightdown boy_rd(.pixel_addr(pixel_boy_rightdown), .Clk(Clk), .data_Out(data_boy_rightdown));
	 
	 girl girl(.pixel_addr(pixel_girl), .Clk(Clk), .data_Out(data_girl));
	 girl_left girl_l(.pixel_addr(pixel_girl_left), .Clk(Clk), .data_Out(data_girl_left));
	 girl_right girl_r(.pixel_addr(pixel_girl_right), .Clk(Clk), .data_Out(data_girl_right));
	 girl_up girl_u(.pixel_addr(pixel_girl_up), .Clk(Clk), .data_Out(data_girl_up));
	 girl_down girl_d(.pixel_addr(pixel_girl_down), .Clk(Clk), .data_Out(data_girl_down));
	 girl_leftup girl_lu(.pixel_addr(pixel_girl_leftup), .Clk(Clk), .data_Out(data_girl_leftup));
	 girl_rightup girl_ru(.pixel_addr(pixel_girl_rightup), .Clk(Clk), .data_Out(data_girl_rightup));
	 girl_leftdown girl_ld(.pixel_addr(pixel_girl_leftdown), .Clk(Clk), .data_Out(data_girl_leftdown));
	 girl_rightdown girl_rd(.pixel_addr(pixel_girl_rightdown), .Clk(Clk), .data_Out(data_girl_rightdown));
	 
	 board_y by(.pixel_addr(pixel_by), .Clk(Clk), .data_Out(data_by));
	 board_p bp(.pixel_addr(pixel_bp), .Clk(Clk), .data_Out(data_bp));
	 box box(.pixel_addr(pixel_box), .Clk(Clk), .data_Out(data_box));
	 button button1(.pixel_addr(pixel_b1), .Clk(Clk), .data_Out(data_b1));
	 button button2(.pixel_addr(pixel_b2), .Clk(Clk), .data_Out(data_b2));
	 button button3(.pixel_addr(pixel_b3), .Clk(Clk), .data_Out(data_b3));
	 diamond_r diamond_1(.pixel_addr(pixel_dr1), .Clk(Clk), .data_Out(data_dr1));
	 diamond_r diamond_2(.pixel_addr(pixel_dr2), .Clk(Clk), .data_Out(data_dr2));
	 diamond_r diamond_3(.pixel_addr(pixel_dr3), .Clk(Clk), .data_Out(data_dr3));
	 diamond_b diamond_4(.pixel_addr(pixel_db1), .Clk(Clk), .data_Out(data_db1));
	 diamond_b diamond_5(.pixel_addr(pixel_db2), .Clk(Clk), .data_Out(data_db2));
	 diamond_b diamond_6(.pixel_addr(pixel_db3), .Clk(Clk), .data_Out(data_db3));
	 diamond_b diamond_7(.pixel_addr(pixel_db4), .Clk(Clk), .data_Out(data_db4));
	 you_win yw(.pixel_addr(pixel_window), .Clk(Clk), .data_Out(data_win));
	 gameover go(.pixel_addr(pixel_window), .Clk(Clk), .data_Out(data_lose));

    always_comb
    begin
		  if (( DistX_window <= 200 && DistX_window >= 0) && ( DistY_window <= 64 && DistY_window >= 0) && data_win!=2'b0 && win == 1)
				win_on = 1'b1;
		  else
				win_on = 1'b0;
		  if (( DistX_window <= 200 && DistX_window >= 0) && ( DistY_window <= 64 && DistY_window >= 0) && data_lose!=2'b0 && lose == 1)
				lose_on = 1'b1;
		  else
				lose_on = 1'b0;
        if ( ( DistX_b <= 20 && DistX_b >= 0) && ( DistY_b <= 35 && DistY_b >= 0) && data_boy!=3'b0 && boy_status == 4'b0) 
            boy_on = 1'b1;
        else 
            boy_on = 1'b0;
		  if (( DistX_b <= 36 && DistX_b >= 0) && ( DistY_b <= 35 && DistY_b >= 0) && data_boy_left!=3'b0 && boy_status == 4'b1)
				boy_left_on = 1'b1;
		  else
				boy_left_on = 1'b0;
		  if (( DistX_b <= 19 && DistX_b >= -17) && ( DistY_b <= 35 && DistY_b >= 0) && data_boy_right!=3'b0 && boy_status == 4'b10)
				boy_right_on = 1'b1;
		  else
				boy_right_on = 1'b0;
		  if (( DistX_b <= 20 && DistX_b >= 0) && ( DistY_b <= 31 && DistY_b >= 0) && data_boy_up!=3'b0 && boy_status == 4'b11)
				boy_up_on = 1'b1;
		  else
				boy_up_on = 1'b0;
		  if (( DistX_b <= 20 && DistX_b >= 0) && ( DistY_b <= 35 && DistY_b >= -5) && data_boy_down!=3'b0 && boy_status == 4'b100)
				boy_down_on = 1'b1;
		  else
				boy_down_on = 1'b0;
		  if (( DistX_b <= 36 && DistX_b >= 0) && ( DistY_b <= 35 && DistY_b >= 0) && data_boy_leftup!=3'b0 && boy_status == 4'b110)
				boy_leftup_on = 1'b1;
		  else
				boy_leftup_on = 1'b0;
		  if (( DistX_b <= 19 && DistX_b >= -17) && ( DistY_b <= 35 && DistY_b >= 0) && data_boy_rightup!=3'b0 && boy_status == 4'b101)
				boy_rightup_on = 1'b1;
		  else
				boy_rightup_on = 1'b0;
		  if (( DistX_b <= 27 && DistX_b >= 0) && ( DistY_b <= 35 && DistY_b >= 0) && data_boy_leftdown!=3'b0 && boy_status == 4'b1000)
				boy_leftdown_on = 1'b1;
		  else
				boy_leftdown_on = 1'b0;
		  if (( DistX_b <= 19 && DistX_b >= -8) && ( DistY_b <= 35 && DistY_b >= 0) && data_boy_rightdown!=3'b0 && boy_status == 4'b111)
				boy_rightdown_on = 1'b1;
		  else
				boy_rightdown_on = 1'b0;
		  if ( ( DistX_g <= 20 && DistX_g >= 0) && ( DistY_g <= 35 && DistY_g >= 0) && data_girl!=3'b0 && girl_status == 4'b0) 
            girl_on = 1'b1;
        else 
            girl_on = 1'b0;
		  if (( DistX_g <= 36 && DistX_g >= 0) && ( DistY_g <= 35 && DistY_g >= 0) && data_girl_left!=3'b0 && girl_status == 4'b1)
				girl_left_on = 1'b1;
		  else
				girl_left_on = 1'b0;
		  if (( DistX_g <= 19 && DistX_g >= -17) && ( DistY_g <= 35 && DistY_g >= 0) && data_girl_right!=3'b0 && girl_status == 4'b10)
				girl_right_on = 1'b1;
		  else
				girl_right_on = 1'b0;
		  if (( DistX_g <= 20 && DistX_g >= 0) && ( DistY_g <= 31 && DistY_g >= 0) && data_girl_up!=3'b0 && girl_status == 4'b11)
				girl_up_on = 1'b1;
		  else
				girl_up_on = 1'b0;
		  if (( DistX_g <= 20 && DistX_g >= 0) && ( DistY_g <= 35 && DistY_g >= -5) && data_girl_down!=3'b0 && girl_status == 4'b100)
				girl_down_on = 1'b1;
		  else
				girl_down_on = 1'b0;
		  if (( DistX_g <= 36 && DistX_g >= 0) && ( DistY_g <= 35 && DistY_g >= 0) && data_girl_leftup!=3'b0 && girl_status == 4'b110)
				girl_leftup_on = 1'b1;
		  else
				girl_leftup_on = 1'b0;
		  if (( DistX_g <= 19 && DistX_g >= -17) && ( DistY_g <= 35 && DistY_g >= 0) && data_girl_rightup!=3'b0 && girl_status == 4'b101)
				girl_rightup_on = 1'b1;
		  else
				girl_rightup_on = 1'b0;
		  if (( DistX_g <= 27 && DistX_g >= 0) && ( DistY_g <= 35 && DistY_g >= 0) && data_girl_leftdown!=3'b0 && girl_status == 4'b1000)
				girl_leftdown_on = 1'b1;
		  else
				girl_leftdown_on = 1'b0;
		  if (( DistX_g <= 19 && DistX_g >= -8) && ( DistY_g <= 35 && DistY_g >= 0) && data_girl_rightdown!=3'b0 && girl_status == 4'b111)
				girl_rightdown_on = 1'b1;
		  else
				girl_rightdown_on = 1'b0;
		  if ( ( DistX_by <= 64 && DistX_by >= 0) && ( DistY_by <= 14 && DistY_by >= 0) )
				board_y_on = 1'b1;
		  else
				board_y_on = 1'b0;
		  if ( ( DistX_bp <= 64 && DistX_bp >= 0) && ( DistY_bp <= 14 && DistY_bp >= 0) )
				board_p_on = 1'b1;
		  else
				board_p_on = 1'b0;
		  if ( ( DistX_box <= 36 && DistX_box >= 0) && ( DistY_box <= 36 && DistY_box >= 0) && data_box!=2'b0)
				box_on = 1'b1;
		  else
				box_on = 1'b0;
		  if ( ( DistX_b1 <= 24 && DistX_b1 >= 0) && ( DistY_b1 <= 6 && DistY_b1 >= 0) && data_b1!=2'b0)
				button1_on = 1'b1;
		  else
				button1_on = 1'b0;
		  if ( ( DistX_b2 <= 24 && DistX_b2 >= 0) && ( DistY_b2 <= 6 && DistY_b2 >= 0) && data_b2!=2'b0)
				button2_on = 1'b1;
		  else
				button2_on = 1'b0;
		  if ( ( DistX_b3 <= 24 && DistX_b3 >= 0) && ( DistY_b3 <= 6 && DistY_b3 >= 0) && data_b3!=2'b0)
				button3_on = 1'b1;
		  else
				button3_on = 1'b0;
		  if ( ( DistX_dr1 <= 20 && DistX_dr1 >= 0) && ( DistY_dr1 <= 16 && DistY_dr1 >= 0) && data_dr1!=3'b0 && diamond_r1 == 0)
				diamond_r1_on = 1'b1;
		  else
				diamond_r1_on = 1'b0;
		  if ( ( DistX_dr2 <= 20 && DistX_dr2 >= 0) && ( DistY_dr2 <= 16 && DistY_dr2 >= 0) && data_dr2!=3'b0 && diamond_r2 == 0)
				diamond_r2_on = 1'b1;
		  else
				diamond_r2_on = 1'b0;
		  if ( ( DistX_dr3 <= 20 && DistX_dr3 >= 0) && ( DistY_dr3 <= 16 && DistY_dr3 >= 0) && data_dr3!=3'b0 && diamond_r3 == 0)
				diamond_r3_on = 1'b1;
		  else
				diamond_r3_on = 1'b0;
		  if ( ( DistX_db1 <= 20 && DistX_db1 >= 0) && ( DistY_db1 <= 16 && DistY_db1 >= 0) && data_db1!=3'b0 && diamond_b1 == 0)
				diamond_b1_on = 1'b1;
		  else
				diamond_b1_on = 1'b0;
		  if ( ( DistX_db2 <= 20 && DistX_db2 >= 0) && ( DistY_db2 <= 16 && DistY_db2 >= 0) && data_db2!=3'b0 && diamond_b2 == 0)
				diamond_b2_on = 1'b1;
		  else
				diamond_b2_on = 1'b0;
		  if ( ( DistX_db3 <= 20 && DistX_db3 >= 0) && ( DistY_db3 <= 16 && DistY_db3 >= 0) && data_db3!=3'b0 && diamond_b3 == 0)
				diamond_b3_on = 1'b1;
		  else
				diamond_b3_on = 1'b0;
		  if ( ( DistX_db4 <= 20 && DistX_db4 >= 0) && ( DistY_db4 <= 16 && DistY_db4 >= 0) && data_db4!=3'b0 && diamond_b4 == 0)
				diamond_b4_on = 1'b1;
		  else
				diamond_b4_on = 1'b0;
     end 
       
    always_comb
    begin:RGB_Display
		  if ((win_on == 1'b1))
				begin 
					Red = col_win[data_win][23:16];
					Green = col_win[data_win][15:8];
					Blue = col_win[data_win][7:0];
				end
		  else if ((lose_on == 1'b1))
				begin 
					Red = col_win[data_lose][23:16];
					Green = col_win[data_lose][15:8];
					Blue = col_win[data_lose][7:0];
				end
		  else 
		  if ((girl_on == 1'b1))
				begin 
					Red = col_g[data_girl][23:16];
					Green = col_g[data_girl][15:8];
					Blue = col_g[data_girl][7:0];
				end
		  else if (girl_left_on == 1'b1)
				begin 
					Red = col_g[data_girl_left][23:16];
					Green = col_g[data_girl_left][15:8];
					Blue = col_g[data_girl_left][7:0];
				end
		  else if (girl_right_on == 1'b1)
				begin 
					Red = col_g[data_girl_right][23:16];
					Green = col_g[data_girl_right][15:8];
					Blue = col_g[data_girl_right][7:0];
				end
		  else if (girl_up_on == 1'b1)
				begin 
					Red = col_g[data_girl_up][23:16];
					Green = col_g[data_girl_up][15:8];
					Blue = col_g[data_girl_up][7:0];
				end
		  else if (girl_down_on == 1'b1)
				begin 
					Red = col_g[data_girl_down][23:16];
					Green = col_g[data_girl_down][15:8];
					Blue = col_g[data_girl_down][7:0];
				end
		  else if (girl_leftup_on == 1'b1)
				begin 
					Red = col_g[data_girl_leftup][23:16];
					Green = col_g[data_girl_leftup][15:8];
					Blue = col_g[data_girl_leftup][7:0];
				end
		  else if (girl_rightup_on == 1'b1)
				begin 
					Red = col_g[data_girl_rightup][23:16];
					Green = col_g[data_girl_rightup][15:8];
					Blue = col_g[data_girl_rightup][7:0];
				end
		  else if (girl_leftdown_on == 1'b1)
				begin 
					Red = col_g[data_girl_leftdown][23:16];
					Green = col_g[data_girl_leftdown][15:8];
					Blue = col_g[data_girl_leftdown][7:0];
				end
		  else if (girl_rightdown_on == 1'b1)
				begin 
					Red = col_g[data_girl_rightdown][23:16];
					Green = col_g[data_girl_rightdown][15:8];
					Blue = col_g[data_girl_rightdown][7:0];
				end
        else if ((boy_on == 1'b1)) 
				begin 
					Red = col_b[data_boy][23:16];
					Green = col_b[data_boy][15:8];
					Blue = col_b[data_boy][7:0];
				end
		  else if (boy_left_on == 1'b1)
				begin 
					Red = col_b[data_boy_left][23:16];
					Green = col_b[data_boy_left][15:8];
					Blue = col_b[data_boy_left][7:0];
				end
		  else if (boy_right_on == 1'b1)
				begin 
					Red = col_b[data_boy_right][23:16];
					Green = col_b[data_boy_right][15:8];
					Blue = col_b[data_boy_right][7:0];
				end
		  else if (boy_up_on == 1'b1)
				begin 
					Red = col_b[data_boy_up][23:16];
					Green = col_b[data_boy_up][15:8];
					Blue = col_b[data_boy_up][7:0];
				end
		  else if (boy_down_on == 1'b1)
				begin 
					Red = col_b[data_boy_down][23:16];
					Green = col_b[data_boy_down][15:8];
					Blue = col_b[data_boy_down][7:0];
				end
		  else if (boy_leftup_on == 1'b1)
				begin 
					Red = col_b[data_boy_leftup][23:16];
					Green = col_b[data_boy_leftup][15:8];
					Blue = col_b[data_boy_leftup][7:0];
				end
		  else if (boy_rightup_on == 1'b1)
				begin 
					Red = col_b[data_boy_rightup][23:16];
					Green = col_b[data_boy_rightup][15:8];
					Blue = col_b[data_boy_rightup][7:0];
				end
		  else if (boy_leftdown_on == 1'b1)
				begin 
					Red = col_b[data_boy_leftdown][23:16];
					Green = col_b[data_boy_leftdown][15:8];
					Blue = col_b[data_boy_leftdown][7:0];
				end
		  else if (boy_rightdown_on == 1'b1)
				begin 
					Red = col_b[data_boy_rightdown][23:16];
					Green = col_b[data_boy_rightdown][15:8];
					Blue = col_b[data_boy_rightdown][7:0];
				end
		  else if (board_y_on == 1'b1)
				begin
					Red = col_by[data_by][23:16];
					Green = col_by[data_by][15:8];
					Blue = col_by[data_by][7:0];
				end
		  else if (board_p_on == 1'b1)
				begin
					Red = col_bp[data_bp][23:16];
					Green = col_bp[data_bp][15:8];
					Blue = col_bp[data_bp][7:0];
				end
		  else if (box_on == 1'b1)
				begin
					Red = col_box[data_box][23:16];
					Green = col_box[data_box][15:8];
					Blue = col_box[data_box][7:0];
				end
		  else if (diamond_r1_on == 1'b1)
				begin
					Red = col_b[data_dr1][23:16];
					Green = col_b[data_dr1][15:8];
					Blue = col_b[data_dr1][7:0];
				end
		  else if (diamond_r2_on == 1'b1)
				begin
					Red = col_b[data_dr2][23:16];
					Green = col_b[data_dr2][15:8];
					Blue = col_b[data_dr2][7:0];
				end
		  else if (diamond_r3_on == 1'b1)
				begin
					Red = col_b[data_dr3][23:16];
					Green = col_b[data_dr3][15:8];
					Blue = col_b[data_dr3][7:0];
				end
		  else if (diamond_b1_on == 1'b1)
				begin
					Red = col_g[data_db1][23:16];
					Green = col_g[data_db1][15:8];
					Blue = col_g[data_db1][7:0];
				end
		  else if (diamond_b2_on == 1'b1)
				begin
					Red = col_g[data_db2][23:16];
					Green = col_g[data_db2][15:8];
					Blue = col_g[data_db2][7:0];
				end
		  else if (diamond_b3_on == 1'b1)
				begin
					Red = col_g[data_db3][23:16];
					Green = col_g[data_db3][15:8];
					Blue = col_g[data_db3][7:0];
				end
		  else if (diamond_b4_on == 1'b1)
				begin
					Red = col_g[data_db4][23:16];
					Green = col_g[data_db4][15:8];
					Blue = col_g[data_db4][7:0];
				end
        else if (button1_on == 1'b1)
				begin
					Red = col_button1[data_b1][23:16];
					Green = col_button1[data_b1][15:8];
					Blue = col_button1[data_b1][7:0];
				end
		  else if (button2_on == 1'b1)
				begin
					Red = col_button2[data_b2][23:16];
					Green = col_button2[data_b2][15:8];
					Blue = col_button2[data_b2][7:0];
				end
		  else if (button3_on == 1'b1)
				begin
					Red = col_button2[data_b3][23:16];
					Green = col_button2[data_b3][15:8];
					Blue = col_button2[data_b3][7:0];
				end
		  else
				begin 
					Red = col[data_bgd][23:16];
					Green = col[data_bgd][15:8];
					Blue = col[data_bgd][7:0];
				end  
    end 
    
endmodule
