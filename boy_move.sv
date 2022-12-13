//-------------------------------------------------------------------------
//    modified from Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  boy_move ( input Reset, frame_clk, win, lose,
					input boy_left, boy_right, boy_up, board_p_up, board_p_down, box_stuck,
					input [9:0] Board_y_X, Board_y_Y, Board_p_X, Board_p_Y, BoxX, BoxY,
               output [9:0]  BoyX, BoyY,
					output [3:0] boy_status);
    
    logic [9:0] Boy_X_Pos, Boy_X_Motion, Boy_Y_Pos, Boy_Y_Motion, Boy_x_Pos, Boy_x_Motion, Boy_y_Pos, Boy_y_Motion;
	 logic [3:0] Status, status;
	 
    parameter [9:0] Boy_X_LEFT=30;  // Center position on the X axis
    parameter [9:0] Boy_Y_TOP=426;  // Center position on the Y axis
    parameter [9:0] Boy_X_Min=16;       // Leftmost point on the X axis
    parameter [9:0] Boy_X_Max=623;     // Rightmost point on the X axis
    parameter [9:0] Boy_Y_Min=16;       // Topmost point on the Y axis
    parameter [9:0] Boy_Y_Max=458;     // Bottommost point on the Y axis
    parameter [9:0] Boy_X_Step=1;      // Step size on the X axis
    parameter [9:0] Boy_Y_Step=1;      // Step size on the Y axis
				 
	 logic [14:0] boy_pixel_0, boy_pixel_1, boy_pixel_2, boy_pixel_3, boy_pixel_4, boy_pixel_5, boy_pixel_6, boy_pixel_7, boy_pixel_8;
	 logic is_wall_0, is_wall_1, is_wall_2, is_wall_3, is_wall_4, is_wall_5, is_wall_6, is_wall_7, is_wall_8;
	 logic [9:0] max_up, max_UP;
	 logic is_board_0, is_board_1, is_board_3, is_board_5, is_board_6, is_board_7, is_board_8;
	 logic is_board_p1, is_board_p2, is_board_p4, is_board_p5, is_board_p6, is_board_p7, is_board_p8;
	 logic left_b, right_b, down_b;
	 
	 enum logic [3:0] {still, left, right, up, down, rightup, leftup, rightdown, leftdown, over}    curr_state, next_state;

	always_ff @ (posedge Reset or posedge frame_clk ) begin
		 if (Reset)  // Asynchronous Reset
        begin 
          Boy_Y_Motion <= 10'd0; //Ball_Y_Step;
			 Boy_X_Motion <= 10'd0; //Ball_X_Step;
			 Boy_Y_Pos <= Boy_Y_TOP;
			 Boy_X_Pos <= Boy_X_LEFT;
			 max_UP <= 10'd44;
			 curr_state <= still;
			 Status <= 4'b0;
        end
		 else begin
			Boy_X_Motion <= Boy_x_Motion;
			Boy_Y_Motion <= Boy_y_Motion;
			Boy_Y_Pos <= Boy_y_Pos;
			Boy_X_Pos <= Boy_x_Pos;
			max_UP <= max_up;
			curr_state <= next_state;
			Status <= status;
		end
	end
	
	assign boy_pixel_0 = Boy_Y_Pos/4*160 + Boy_X_Pos*1/4;
	assign boy_pixel_1 = boy_pixel_0 + 163;
	assign boy_pixel_2 = boy_pixel_0 + 164;
	assign boy_pixel_3 = boy_pixel_0 + 17/4*160;
	assign boy_pixel_4 = boy_pixel_0 + 17/4*160 + 4;
	assign boy_pixel_5 = boy_pixel_0 + 31/4*160 + 2;
	assign boy_pixel_6 = boy_pixel_0 + 31/4*160 + 3;
	assign boy_pixel_7 = boy_pixel_0 + 32/4*160 + 2;
	assign boy_pixel_8 = boy_pixel_0 + 32/4*160 + 3;
	
	wall wall0(.pixel_addr(boy_pixel_0 + 161), .data_Out(is_wall_0));
	wall wall1(.pixel_addr(boy_pixel_1), .data_Out(is_wall_1));
	wall wall2(.pixel_addr(boy_pixel_2), .data_Out(is_wall_2));
	wall wall3(.pixel_addr(boy_pixel_3), .data_Out(is_wall_3));
	wall wall4(.pixel_addr(boy_pixel_4), .data_Out(is_wall_4));
	wall wall5(.pixel_addr(boy_pixel_5), .data_Out(is_wall_5));
	wall wall6(.pixel_addr(boy_pixel_6), .data_Out(is_wall_6));
	wall wall7(.pixel_addr(boy_pixel_7), .data_Out(is_wall_7));
	wall wall8(.pixel_addr(boy_pixel_8), .data_Out(is_wall_8));
	
	collide_board y0(.BoardX(Board_y_X), .BoardY(Board_y_Y), .Boy_x_Pos(Boy_X_Pos+1), .Boy_y_Pos(Boy_Y_Pos+1),.is_board(is_board_0));
	collide_board y1(.BoardX(Board_y_X), .BoardY(Board_y_Y), .Boy_x_Pos(Boy_X_Pos+10), .Boy_y_Pos(Boy_Y_Pos+1),.is_board(is_board_1));
	collide_board y3(.BoardX(Board_y_X), .BoardY(Board_y_Y), .Boy_x_Pos(Boy_X_Pos), .Boy_y_Pos(Boy_Y_Pos+17),.is_board(is_board_3));
	collide_board y5(.BoardX(Board_y_X), .BoardY(Board_y_Y), .Boy_x_Pos(Boy_X_Pos+8), .Boy_y_Pos(Boy_Y_Pos+31),.is_board(is_board_5));
	collide_board y6(.BoardX(Board_y_X), .BoardY(Board_y_Y), .Boy_x_Pos(Boy_X_Pos+12), .Boy_y_Pos(Boy_Y_Pos+31),.is_board(is_board_6));
	collide_board y7(.BoardX(Board_y_X), .BoardY(Board_y_Y), .Boy_x_Pos(Boy_X_Pos+8), .Boy_y_Pos(Boy_Y_Pos+34),.is_board(is_board_7));
	collide_board y8(.BoardX(Board_y_X), .BoardY(Board_y_Y), .Boy_x_Pos(Boy_X_Pos+12), .Boy_y_Pos(Boy_Y_Pos+34),.is_board(is_board_8));
	
	collide_board p1(.BoardX(Board_p_X), .BoardY(Board_p_Y), .Boy_x_Pos(Boy_X_Pos+10), .Boy_y_Pos(Boy_Y_Pos+1),.is_board(is_board_p1));
	collide_board p2(.BoardX(Board_p_X), .BoardY(Board_p_Y), .Boy_x_Pos(Boy_X_Pos+16), .Boy_y_Pos(Boy_Y_Pos+1),.is_board(is_board_p2));
	collide_board p4(.BoardX(Board_p_X), .BoardY(Board_p_Y), .Boy_x_Pos(Boy_X_Pos+20), .Boy_y_Pos(Boy_Y_Pos+17),.is_board(is_board_p4));
	collide_board p5(.BoardX(Board_p_X), .BoardY(Board_p_Y), .Boy_x_Pos(Boy_X_Pos+8), .Boy_y_Pos(Boy_Y_Pos+31),.is_board(is_board_p5));
	collide_board p6(.BoardX(Board_p_X), .BoardY(Board_p_Y), .Boy_x_Pos(Boy_X_Pos+12), .Boy_y_Pos(Boy_Y_Pos+31),.is_board(is_board_p6));
	collide_board p7(.BoardX(Board_p_X), .BoardY(Board_p_Y), .Boy_x_Pos(Boy_X_Pos+8), .Boy_y_Pos(Boy_Y_Pos+34),.is_board(is_board_p7));
	collide_board p8(.BoardX(Board_p_X), .BoardY(Board_p_Y), .Boy_x_Pos(Boy_X_Pos+12), .Boy_y_Pos(Boy_Y_Pos+34),.is_board(is_board_p8));
	
	collide_box cbb(.BoxX(BoxX),
					 .BoxY(BoxY),
					 .Fig_x_Pos(BoyX),
					 .Fig_y_Pos(BoyY),
					 .is_box_left(left_b),
					 .is_box_right(right_b),
					 .is_box_down(down_b),
					 );
	
	logic up_enable_wall, down_enable_wall, left_enable_wall, right_enable_wall, left_up_enable_wall, right_up_enable_wall;
	logic left_down_enable_wall, right_down_enable_wall;
	logic up_enable_board, down_enable_board, left_enable_board, right_up_enable_board, left_up_enable_board;
	logic right_down_enable_board, left_down_enable_board, right_enable_board;
	logic left_enable_box, right_enable_box, down_enable_box;
	
	always_comb begin
		if (box_stuck && left_b == 1)
			left_enable_box = 1'b1;
		else
			left_enable_box = 1'b0;
		if (box_stuck && right_b == 1)
			right_enable_box = 1'b1;
		else
			right_enable_box = 1'b0;
		if (down_b == 1)
			down_enable_box = 1'b1;
		else
			down_enable_box = 1'b0;
	end
			
	always_comb begin
		up_enable_wall =  (is_wall_0 || is_wall_1 || is_wall_2);
		down_enable_wall = (is_wall_7 || is_wall_8);
		left_enable_wall = (is_wall_3 || is_wall_0);
		right_enable_wall = (is_wall_2 || is_wall_4);
		right_up_enable_wall = (is_wall_0||is_wall_1||is_wall_2||is_wall_4);
		left_up_enable_wall = (is_wall_0||is_wall_1||is_wall_2||is_wall_3);
		left_down_enable_wall = (is_wall_7 || is_wall_8 || is_wall_3);
		right_down_enable_wall = (is_wall_7 || is_wall_8 || is_wall_4);
		up_enable_board = (is_board_0 || is_board_1 || is_board_p1);
		down_enable_board = (is_board_7 || is_board_8 ||is_board_p7 || is_board_p8);
		left_enable_board = (is_board_0 || is_board_3);
		right_enable_board = (is_board_p2 || is_board_p4 || is_board_p6);
		left_up_enable_board = (is_board_0 || is_board_1 || is_board_3 || is_board_p1 || is_board_p2);
		right_up_enable_board = (is_board_0 || is_board_1 || is_board_p1 || is_board_p2 || is_board_p4);
		right_down_enable_board = (is_board_7 || is_board_8 || is_board_p7 || is_board_p8 || is_board_p4);
		left_down_enable_board = (is_board_7 || is_board_8 || is_board_3 || is_board_p7 || is_board_p8);
	end
	
		always_comb begin
		next_state  = curr_state;
		unique case(curr_state)
			still: begin
						if ((win == 1) || (lose == 1))
							next_state = over;
						else if (down_enable_wall == 0 && down_enable_board == 0 && down_enable_box == 0)
							next_state = down;
						else if (boy_left == 1'b1 && boy_up == 1'b0 && left_enable_wall == 0 && left_enable_board == 0 && left_enable_box == 0)
							next_state = left;
						else if (boy_right == 1'b1 && boy_up == 1'b0 && right_enable_wall == 0 && right_enable_board == 0 && right_enable_box == 0)
							next_state = right;
						else if (boy_up == 1'b1 && ((boy_right||boy_left) == 1'b0) && up_enable_wall == 0 && up_enable_board == 0)
							next_state = up;
						else if ((boy_right == 1'b1) && boy_up == 1'b1 && right_up_enable_wall == 0 && right_up_enable_board == 0)
							next_state = rightup;
						else if (boy_left == 1'b1 && boy_up == 1'b1 && left_up_enable_wall == 0 && left_up_enable_board == 0)
							next_state = leftup;
						else
							next_state = still;
						end
			left: begin
						if ((win == 1) || (lose == 1))
							next_state = over;
						else if (down_enable_wall == 0 && down_enable_board == 0 && down_enable_box == 0)
							next_state = leftdown;
						else if (boy_left == 1'b1 && boy_up == 1'b0 && left_enable_wall == 0  && left_enable_board == 0 && left_enable_box == 0)
							next_state = left;
						else if (boy_right == 1'b1 && boy_up == 1'b0 && right_enable_wall == 0 && right_enable_board == 0 && right_enable_box == 0)
							next_state = right;
						else if (boy_up == 1'b1 && ((boy_right||boy_left) == 1'b0) && up_enable_wall == 0 && up_enable_board == 0)
							next_state = up;
						else if (boy_left == 1'b1 && boy_up == 1'b1 && left_up_enable_wall == 0 && left_up_enable_board == 0)
							next_state = leftup;
						else
							next_state = still;
					end
			right: begin
						if ((win == 1) || (lose == 1))
							next_state = over;
						else if (down_enable_wall == 0 && down_enable_board == 0 && down_enable_box == 0)
							next_state = rightdown;
						else if (boy_left == 1'b1 && boy_up == 1'b0 && left_enable_wall == 0  && left_enable_board == 0 && left_enable_box == 0)
							next_state = left;
						else if (boy_right == 1'b1 && boy_up == 1'b0 && right_enable_wall == 0 && right_enable_board == 0 && right_enable_box == 0)
							next_state = right;
						else if (boy_up == 1'b1 && ((boy_right||boy_left) == 1'b0) && up_enable_wall == 0 && up_enable_board == 0)
							next_state = up;
						else if (boy_right == 1'b1 && boy_up == 1'b1 && right_up_enable_wall == 0 && right_up_enable_board == 0)
							next_state = rightup;
						else
							next_state = still;
					end
			up: begin
					if ((win == 1) || (lose == 1))
						next_state = over;
					else if (max_up > 10'd0 && up_enable_wall == 0 && up_enable_board == 0)
						next_state = up;
					else
						next_state = down;
				end
			down: begin
						if ((win == 1) || (lose == 1))
							next_state = over;
						else if (down_enable_wall == 0 && down_enable_board == 0 && down_enable_box == 0)
							next_state = down;
						else
							next_state = still;
					end
			rightup: begin
				if ((win == 1) || (lose == 1))
					next_state = over;
				else if (max_up <= 10'd0)
					next_state = rightdown;
				else if (right_up_enable_wall == 0 && right_up_enable_board == 0 && right_enable_box == 0)
					next_state = rightup;
				else
					next_state = down;
				end 
			leftup: begin
				if ((win == 1) || (lose == 1))
					next_state = over;
				else if (max_up <= 10'd0)
					next_state = leftdown;
				else if (left_up_enable_wall == 0 && left_up_enable_board == 0 && left_enable_box == 0)
					next_state = leftup;
				else
					next_state = down;
				end
			rightdown: begin
				if ((win == 1) || (lose == 1))
					next_state = over;
				else if (right_down_enable_wall == 0 && right_down_enable_board == 0 && down_enable_box == 0 && right_enable_box == 0)
					next_state = rightdown;
				else if (down_enable_wall == 0 && down_enable_board == 0 && down_enable_box == 0)
					next_state = down;
				else
					next_state = still;
			end
			leftdown: begin
				if ((win == 1) || (lose == 1))
					next_state = over;
				else if (left_down_enable_wall == 0 && left_down_enable_board == 0 && down_enable_box == 0 && left_enable_box == 0)
					next_state = leftdown;
				else if (down_enable_wall == 0 && down_enable_board == 0 && down_enable_box == 0)
					next_state = down;
				else
					next_state = still;
			end
			over: begin
				next_state = over;
			end
		endcase
	end
	 
	always_comb begin
		Boy_x_Motion = Boy_X_Motion;
		Boy_y_Motion = Boy_Y_Motion;
		Boy_y_Pos = Boy_Y_Pos;
		Boy_x_Pos = Boy_X_Pos;
		status = Status;
		max_up = max_UP;
		unique case (curr_state)
			still: begin
				Boy_y_Motion = 10'd0;
				Boy_x_Motion = 10'd0;
				if ((board_p_up == 1) && ((is_board_p7 == 1) || (is_board_p8 == 1))) begin
					Boy_y_Motion = Boy_y_Motion - 1;
				end
				else if ((board_p_up == 1) && ((is_board_p7 == 1) || (is_board_p8 == 1))) begin
					Boy_y_Motion = Boy_y_Motion + 1;
				end
				Boy_y_Pos = Boy_y_Pos + Boy_y_Motion;
				Boy_x_Pos = Boy_x_Pos + Boy_x_Motion;
				if (boy_left == 1)
					status = 4'b0001;
				else if (boy_right == 1)
					status = 4'b0010;
				else
					status = 4'b0000;
			end
			left: begin //A
				if (is_wall_5 == 0 && is_board_5 == 0) begin
					Boy_x_Motion = -1;
					Boy_y_Motion = 0;
				end
				else begin
					Boy_x_Motion = 0;
					Boy_y_Motion = -1;
				end
				if ((board_p_up == 1) && ((is_board_p7 == 1) || (is_board_p8 == 1))) begin
					Boy_y_Motion = Boy_y_Motion - 1;
				end
				else if ((board_p_up == 1) && ((is_board_p7 == 1) || (is_board_p8 == 1))) begin
					Boy_y_Motion = Boy_y_Motion + 1;
				end
				Boy_y_Pos = Boy_y_Pos + Boy_y_Motion;
				Boy_x_Pos = Boy_x_Pos + Boy_x_Motion;
				status = 4'b0001;
			end
			right: begin //D
				if (is_wall_6 == 0 && is_board_6 == 0) begin
					Boy_x_Motion = 1;//D
					Boy_y_Motion = 0;
				end
				else begin
					Boy_x_Motion = 0;//D
					Boy_y_Motion = -1;
				end
				if ((board_p_up == 1) && ((is_board_p7 == 1) || (is_board_p8 == 1))) begin
					Boy_y_Motion = Boy_y_Motion - 1;
				end
				else if ((board_p_up == 1) && ((is_board_p7 == 1) || (is_board_p8 == 1))) begin
					Boy_y_Motion = Boy_y_Motion + 1;
				end
				Boy_y_Pos = Boy_y_Pos + Boy_y_Motion;
				Boy_x_Pos = Boy_x_Pos + Boy_x_Motion;
				status = 4'b0010;
			end
			up: begin //W
				if (max_up >= 10'd25) begin
					Boy_y_Motion = -2;//W
					Boy_x_Motion = 0;
				end
				else begin
					Boy_y_Motion = -1;//W
					Boy_x_Motion = 0;
				end
				if ((board_p_up == 1) && ((is_board_p7 == 1) || (is_board_p8 == 1))) begin
					Boy_y_Motion = Boy_y_Motion - 1;
				end
				else if ((board_p_up == 1) && ((is_board_p7 == 1) || (is_board_p8 == 1))) begin
					Boy_y_Motion = Boy_y_Motion + 1;
				end
				Boy_y_Pos = Boy_y_Pos + Boy_y_Motion;
				Boy_x_Pos = Boy_x_Pos + Boy_x_Motion;
				max_up = max_up - 1;
				status = 4'b0011;
			end
			down: begin
				Boy_y_Motion = 1;
				Boy_x_Motion = 0;
				max_up = 10'd44;
				Boy_y_Pos = Boy_y_Pos + Boy_y_Motion;
				Boy_x_Pos = Boy_x_Pos + Boy_x_Motion;
				status = 4'b0100;
			end
			rightup: begin
				if (max_up >= 10'd23) begin
					Boy_y_Motion = -2;//W
					Boy_x_Motion = 1;
				end
				else if (max_up <= 10'd12) begin
					Boy_y_Motion = 0;
					Boy_x_Motion = 1;
				end
				else begin
					Boy_y_Motion = -1;//W
					Boy_x_Motion = 1;
				end
				if ((board_p_up == 1) && ((is_board_p7 == 1) || (is_board_p8 == 1))) begin
					Boy_y_Motion = Boy_y_Motion - 1;
				end
				else if ((board_p_up == 1) && ((is_board_p7 == 1) || (is_board_p8 == 1))) begin
					Boy_y_Motion = Boy_y_Motion + 1;
				end
				Boy_y_Pos = Boy_y_Pos + Boy_y_Motion;
				Boy_x_Pos = Boy_x_Pos + Boy_x_Motion;
				status = 4'b0101;
				max_up = max_up - 1;
			end
			leftup: begin
				if (max_up >= 10'd23) begin
					Boy_y_Motion = -2;//W
					Boy_x_Motion = -1;
				end
				else if (max_up <= 10'd12) begin
					Boy_y_Motion = 0;
					Boy_x_Motion = -1;
				end
				else begin
					Boy_y_Motion = -1;//W
					Boy_x_Motion = -1;
				end
				if ((board_p_up == 1) && ((is_board_p7 == 1) || (is_board_p8 == 1))) begin
					Boy_y_Motion = Boy_y_Motion + 1;
				end
				else if ((board_p_up == 1) && ((is_board_p7 == 1) || (is_board_p8 == 1))) begin
					Boy_y_Motion = Boy_y_Motion + 1;
				end
				Boy_y_Pos = Boy_y_Pos + Boy_y_Motion;
				Boy_x_Pos = Boy_x_Pos + Boy_x_Motion;
				status = 4'b0110;
				max_up = max_up - 1;
			end
			rightdown: begin
				Boy_y_Motion = 1;
				Boy_x_Motion = 1;
				max_up = 10'd44;
				Boy_y_Pos = Boy_y_Pos + Boy_y_Motion;
				Boy_x_Pos = Boy_x_Pos + Boy_x_Motion;
				status = 4'b0111;
			end
			leftdown: begin
				Boy_y_Motion = 1;
				Boy_x_Motion = -1;
				max_up = 10'd44;
				Boy_y_Pos = Boy_y_Pos + Boy_y_Motion;
				Boy_x_Pos = Boy_x_Pos + Boy_x_Motion;
				status = 4'b1000;
			end
			over: begin
				Boy_y_Motion = 0;
				Boy_x_Motion = 0;
				Boy_y_Pos = Boy_y_Pos + Boy_y_Motion;
				Boy_x_Pos = Boy_x_Pos + Boy_x_Motion;
			end
		endcase
    end
    	 
    assign BoyX = Boy_X_Pos;
   
    assign BoyY = Boy_Y_Pos;
    
	 assign boy_status = Status;
endmodule

