module board_p_move (
	input Reset, frame_clk,
	input [9:0] BoyX, BoyY, GirlX, GirlY,
	output [9:0] BoardX, BoardY,
	output logic is_up, is_down
);
	
	logic [9:0] Board_X_Pos, Board_X_Motion, Board_Y_Pos, Board_Y_Motion;
	logic button_pushed, Is_up, Is_down;
	parameter [9:0] Board_X_LEFT=280*2;
   parameter [9:0] Board_Y_TOP=99*2;
	int DistX_1b, DistY_1b, DistX_2b, DistY_2b, DistX_1g, DistY_1g, DistX_2g, DistY_2g;
	assign DistX_1b = (BoyX+10) - 83*2;
	assign DistY_1b = 125*2 - (BoyY+35);
	assign DistX_2b = (BoyX+10) - 249*2;
	assign DistY_2b = 94*2 - (BoyY+35);
	assign DistX_1g = (GirlX+10) - 83*2;
	assign DistY_1g = 125*2 - (GirlY+35);
	assign DistX_2g = (GirlX+10) - 249*2;
	assign DistY_2g = 94*2 - (GirlY+35);
	
	logic boy_push, girl_push;
	
	always_comb begin
		boy_push = ((DistX_1b <= 10 && DistY_1b <=5 && DistX_1b >=0 && DistY_1b >= -5)||(DistX_2b <= 10 && DistY_2b <=5 && DistX_2b >=0 && DistY_2b >= -5));
		girl_push = ((DistX_1g <= 10 && DistY_1g <=5 && DistX_1g >=0 && DistY_1g >= -5)||(DistX_2g <= 10 && DistY_2g <=5 && DistX_2g >=0 && DistY_2g >= -5));
		if (boy_push || girl_push)
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
				Is_up <= 1'b0;
				Is_down <= 1'b0;
        end
		 else if (Board_Y_Pos <= 250 && button_pushed == 1 && (Board_X_Pos<=BoyX+20 && Board_Y_Pos+14>=BoyY && Board_Y_Pos<=BoyY) == 0 && (Board_X_Pos<=GirlX+20 && Board_Y_Pos+14>=GirlY && Board_Y_Pos<=GirlY) == 0) begin
				Board_Y_Motion <= 1;
				Board_X_Motion <= 0;
				Board_Y_Pos <= (Board_Y_Pos + Board_Y_Motion);
				Board_X_Pos <= (Board_X_Pos + Board_X_Motion);
				Is_up <= 1'b0;
				Is_down <= 1'b1;
		 end
		 else if (Board_Y_Pos >= 198 && button_pushed == 0) begin
				Board_Y_Motion <= -1;
				Board_X_Motion <= 0;
				Board_Y_Pos <= (Board_Y_Pos + Board_Y_Motion);
				Board_X_Pos <= (Board_X_Pos + Board_X_Motion);
				Is_up <= 1'b1;
				Is_down <= 1'b0;
		 end
		 else begin
			Board_Y_Motion <= 0;
			Board_X_Motion <= 0;
			Board_Y_Pos <= (Board_Y_Pos + Board_Y_Motion);
			Board_X_Pos <= (Board_X_Pos + Board_X_Motion);
			Is_up <= 1'b0;
			Is_down <= 1'b0;
		end
	 end
	 
	 assign BoardX = Board_X_Pos;
   
    assign BoardY = Board_Y_Pos;
	 
	 assign is_up = Is_up;
	 
	 assign is_down = Is_down;
	 
	 
endmodule
