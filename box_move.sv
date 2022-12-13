module box_move ( input Reset, frame_clk,
						input [3:0] boy_status, girl_status, 
						input [9:0] BoyX, BoyY, GirlX, GirlY,
						output [9:0] BoxX, BoxY,
						output is_stuck
);

	parameter [9:0] Box_X_LEFT=360;
   parameter [9:0] Box_Y_TOP=149-36;
	
	logic [9:0] Box_X_Pos, Box_X_Motion, Box_Y_Pos, Box_Y_Motion, Box_x_Pos, Box_x_Motion, Box_y_Pos, Box_y_Motion;
	logic box_left, box_right;
	logic left_b, right_b, down_b, left_g, right_g, down_g;
	logic Stuck, stuck;
	
	enum logic [1:0] {still, left, right, down}    curr_state, next_state;

	always_ff @ (posedge Reset or posedge frame_clk ) begin
		 if (Reset)  // Asynchronous Reset
        begin 
            Box_Y_Motion <= 10'd0;
				Box_X_Motion <= 10'd0;
				Box_Y_Pos <= Box_Y_TOP;
				Box_X_Pos <= Box_X_LEFT;
				Stuck <= 1'b0;
        end
		 else begin
			Box_X_Motion <= Box_x_Motion;
			Box_Y_Motion <= Box_y_Motion;
			Box_Y_Pos <= Box_y_Pos;
			Box_X_Pos <= Box_x_Pos;
			curr_state <= next_state;
			Stuck <= stuck;
		end
	end
	
	collide_box cb1(.BoxX(Box_X_Pos),
					 .BoxY(Box_Y_Pos),
					 .Fig_x_Pos(BoyX),
					 .Fig_y_Pos(BoyY),
					 .is_box_left(left_b),
					 .is_box_right(right_b),
					 .is_box_down(down_b)
					 );
	
	collide_box cb2(.BoxX(Box_X_Pos),
					 .BoxY(Box_Y_Pos),
					 .Fig_x_Pos(GirlX),
					 .Fig_y_Pos(GirlY),
					 .is_box_left(left_g),
					 .is_box_right(right_g),
					 .is_box_down(down_g)
					 );
	
	always_comb begin
		//left
		if (left_b==1 && ((boy_status == 4'b0001) || (boy_status == 4'b0110) || (boy_status == 4'b1000)))
			box_left = 1'b1;
		else if (left_g==1 && ((girl_status == 4'b0001) || (girl_status == 4'b0110) || (girl_status == 4'b1000)))
			box_left = 1'b1;
		else
			box_left = 1'b0;
		if (right_b==1 && ((boy_status == 4'b0010) || (boy_status == 4'b0101) || (boy_status == 4'b0111)))
			box_right = 1'b1;
		else if (right_g==1 && ((girl_status == 4'b0010) || (girl_status == 4'b0101) || (girl_status == 4'b0111)))
			box_right = 1'b1;
		else
			box_right = 1'b0;
			
		if ((left_g && right_b == 1) || (left_b && right_g == 1)) begin
			box_left = 1'b0;
			box_right = 1'b0;
		end
	end
		
	always_comb begin
		next_state  = curr_state;
		unique case(curr_state)
			still: begin
				if ((Box_X_Pos >= 139*2) && (Box_X_Pos+36 <= 165*2) && (Box_Y_Pos+36 < 183))
					next_state = down;
				else if ((box_left == 1'b1) && ((Box_X_Pos >= 98)))
					next_state = left;
				else if ((box_right == 1'b1) && (Box_X_Pos+36 <= 330))
					next_state = right;
				else
					next_state = still;
				end
			down: begin
				if (Box_Y_Pos+36 >= 183)
					next_state = still;
				else
					next_state = down;
				end
			left: begin
				if ((Box_X_Pos >= 139*2) && (Box_X_Pos+36 <= 165*2) && (Box_Y_Pos+36 < 183))
					next_state = down;
				else if ((box_left == 1'b1) && (Box_X_Pos >= 98))
					next_state = left;
				else if ((box_right == 1'b1) && (Box_X_Pos+36 <= 330))
					next_state = right;
				else
					next_state = still;
				end
			right: begin
				if ((box_left == 1'b1) && ((Box_X_Pos >= 98)))
					next_state = left;
				else if ((box_right == 1'b1) && (Box_X_Pos+36 <= 330))
					next_state = right;
				else
					next_state = still;
				end
		endcase
	end
	
	always_comb begin
		Box_x_Motion = Box_X_Motion;
		Box_y_Motion = Box_Y_Motion;
		Box_y_Pos = Box_Y_Pos;
		Box_x_Pos = Box_X_Pos;
		stuck = Stuck;
		unique case (curr_state)
			still: begin
				Box_y_Motion = 10'd0;
				Box_x_Motion = 10'd0;
				Box_y_Pos = Box_y_Pos + Box_y_Motion;
				Box_x_Pos = Box_x_Pos + Box_x_Motion;
				if ((left_g && right_b == 1) || (left_b && right_g == 1) || (Box_X_Pos <= 98) || (Box_X_Pos+36 == 330))
					stuck = 1'b1;
				else
					stuck = 1'b0;
			end
			down: begin
				if ((Box_X_Pos >= 139*2) && (Box_X_Pos+36 < 165*2)) begin
					Box_y_Motion = 1;
					Box_x_Motion = -1;
					Box_y_Pos = (Box_y_Pos + Box_y_Motion);
					Box_x_Pos = (Box_x_Pos + Box_x_Motion);
					stuck = 1'b0;
				end
				else if ((Box_X_Pos <= 277) && (Box_Y_Pos+36 <= 183)) begin
					Box_y_Motion = 2;
					Box_x_Motion = 0;
					Box_y_Pos = (Box_y_Pos + Box_y_Motion);
					Box_x_Pos = (Box_x_Pos + Box_x_Motion);
					stuck = 1'b0;
				end
			end
			left: begin
				Box_y_Motion = 0;
				Box_x_Motion = -1;
				Box_y_Pos = (Box_y_Pos + Box_y_Motion);
				Box_x_Pos = (Box_x_Pos + Box_x_Motion);
				stuck = 1'b0;
			end
			right: begin
				Box_y_Motion = 0;
				Box_x_Motion = 1;
				Box_y_Pos = (Box_y_Pos + Box_y_Motion);
				Box_x_Pos = (Box_x_Pos + Box_x_Motion);
				stuck = 1'b0;
			end
		endcase
	end
	
	assign BoxX = Box_X_Pos;
   
   assign BoxY = Box_Y_Pos;
	 
	assign is_stuck = Stuck;
		
endmodule
	