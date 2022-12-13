module collide_box ( input [9:0] BoxX, BoxY, Fig_x_Pos, Fig_y_Pos,
							output logic is_box_left, is_box_right, is_box_down
);
	
	always_comb begin 
		if ((Fig_x_Pos <= BoxX+36) && (Fig_x_Pos >= BoxX+25) && (Fig_y_Pos+32 > BoxY) && (Fig_y_Pos < BoxY+36))
			is_box_left = 1'b1;
		else
			is_box_left = 1'b0;
		if ((Fig_x_Pos+20 <= BoxX+5) && (Fig_x_Pos+20 >= BoxX) && (Fig_y_Pos+32 > BoxY) && (Fig_y_Pos < BoxY+36))
			is_box_right = 1'b1;
		else
			is_box_right = 1'b0;
		if ((Fig_x_Pos + 10 >= BoxX) && (Fig_x_Pos + 10 <= BoxX+36) && (Fig_y_Pos+30 < BoxY) && (Fig_y_Pos+35 >= BoxY))
			is_box_down = 1'b1;
		else
			is_box_down = 1'b0;
	end
	
endmodule
