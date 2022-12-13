module board_y_move (
	input Reset, frame_clk,
	input [9:0] BoyX, BoyY, GirlX, GirlY,
	output [9:0] BoardX, BoardY
);
	
	logic [9:0] Board_X_Pos, Board_X_Motion, Board_Y_Pos, Board_Y_Motion;
	logic button_pushed, boy_not_collide, girl_not_collide;
	parameter [9:0] Board_X_LEFT=14;
   parameter [9:0] Board_Y_TOP=248;
	int DistX_1, DistY_1, DistX_2, DistY_2;
	assign DistX_1 = (BoyX+10) - 69*2;
	assign DistY_1 = 168*2 - (BoyY+35);
	assign DistX_2 = (GirlX+10) - 69*2;
	assign DistY_2 = 168*2 - (GirlY+35);
	
	always_comb begin
		boy_not_collide = ((Board_X_Pos+64>=BoyX && Board_Y_Pos+14<=BoyY)||Board_X_Pos+64<=BoyX);
		girl_not_collide = ((Board_X_Pos+64>=GirlX && Board_Y_Pos+14<=GirlY)||Board_X_Pos+64<=GirlX);
		if ((DistX_1 <= 10 && DistY_1 <=5 && DistX_1 >=0 && DistY_1 >= -5) || (DistX_2 <= 10 && DistY_2 <=5 && DistX_2 >=0 && DistY_2 >= -5))
			button_pushed = 1;
		else
			button_pushed = 0;
	end
	
	always_ff @ (posedge Reset or posedge frame_clk )
    begin
       if (Reset)
        begin 
            Board_Y_Motion <= 10'd0;
				Board_X_Motion <= 10'd0;
				Board_Y_Pos <= Board_Y_TOP;
				Board_X_Pos <= Board_X_LEFT;
        end
		 else if (Board_Y_Pos <= 300 && button_pushed == 1 && boy_not_collide == 1 && girl_not_collide == 1) begin
				Board_Y_Motion <= 1;
				Board_X_Motion <= 0;
				Board_Y_Pos <= (Board_Y_Pos + Board_Y_Motion);
				Board_X_Pos <= (Board_X_Pos + Board_X_Motion);
		 end
		 else begin
				Board_Y_Motion <= 0;
				Board_X_Motion <= 0;
				Board_Y_Pos <= (Board_Y_Pos + Board_Y_Motion);
				Board_X_Pos <= (Board_X_Pos + Board_X_Motion);
		 end
	 end
	 
	 assign BoardX = Board_X_Pos;
   
    assign BoardY = Board_Y_Pos;
	 
	 
endmodule
