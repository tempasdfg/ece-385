module collide_board ( input [9:0] BoardX, BoardY, Boy_x_Pos, Boy_y_Pos,
								 output logic is_board
								 );
	
	always_comb begin
		if ((BoardX <= Boy_x_Pos) && (BoardX+64 >= Boy_x_Pos) && (BoardY+14 >= Boy_y_Pos) && (BoardY <= Boy_y_Pos))
			is_board = 1'b1;
		else
			is_board = 1'b0;
	end
endmodule
