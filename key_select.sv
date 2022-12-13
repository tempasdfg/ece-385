module key_select (input [7:0] keycode0, keycode1, keycode2, keycode3,
						 input Clk,
						 output logic boy_left, boy_right, boy_up, girl_left, girl_right, girl_up, Reset
);

	always_ff @ ( posedge Clk ) begin
		if (keycode0 == 8'h2c)
			Reset = 1'b1;
		
		else begin
			if (keycode0 == 8'h04 || keycode1 == 8'h04 || keycode2 == 8'h04 || keycode3 == 8'h04)
				boy_left = 1'b1;
			else
				boy_left = 1'b0;
			if (keycode0 == 8'h07 || keycode1 == 8'h07 || keycode2 == 8'h07 || keycode3 == 8'h07)
				boy_right = 1'b1;
			else
				boy_right = 1'b0;
			if (keycode0 == 8'h1a || keycode1 == 8'h1a || keycode2 == 8'h1a || keycode3 == 8'h1a)
				boy_up = 1'b1;
			else
				boy_up = 1'b0;
		
			if (boy_left == 1'b1 && boy_right == 1'b1) begin
				boy_left = 1'b0;
				boy_right = 1'b0;
				boy_up = 1'b0;
			end
		
			if (keycode0 == 8'h50 || keycode1 == 8'h50 || keycode2 == 8'h50 || keycode3 == 8'h50)
				girl_left = 1'b1;
			else
				girl_left = 1'b0;
			if (keycode0 == 8'h4f || keycode1 == 8'h4f || keycode2 == 8'h4f || keycode3 == 8'h4f)
				girl_right = 1'b1;
			else
				girl_right = 1'b0;
			if (keycode0 == 8'h52 || keycode1 == 8'h52 || keycode2 == 8'h52 || keycode3 == 8'h52)
				girl_up = 1'b1;
			else
				girl_up = 1'b0;
		
			if (girl_left == 1'b1 && girl_right == 1'b1) begin
				girl_left = 1'b0;
				girl_right = 1'b0;
				girl_up = 1'b0;
			end
		end
	end
		
endmodule
