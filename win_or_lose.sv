module win_or_lose ( input Reset, frame_clk,
							input [9:0] BoyX, BoyY, GirlX, GirlY,
							output logic win, lose
);
	
	logic boy_dead, girl_dead, boy_win, girl_win, Win, Lose;
	
	always_comb begin
		if (BoyX+10 >=221*2 && BoyX+10 <= 248*2 && BoyY+35 >=231*2-2)
			boy_dead = 1'b1;
		else if (BoyX+10 >=204*2 && BoyX+10 <= 232*2 && BoyY+35 >=181*2-2 && BoyY+35 <= 185*2-2)
			boy_dead = 1'b1;
		else
			boy_dead = 1'b0;
		if (GirlX+10 >=156*2 && GirlX+10 <= 182*2 && GirlY+35 >=231*2-2)
			girl_dead = 1'b1;
		else if (GirlX+10 >=203*2 && GirlX+10 <= 232*2 && GirlY+35 >=181*2-2 && GirlY+35 <= 185*2-2)
			girl_dead = 1'b1;
		else
			girl_dead = 1'b0;
	end
	
	always_comb begin
		if (BoyX >=262*2 && BoyX <= 275*2 && BoyY <=50*2)
			boy_win = 1'b1;
		else
			boy_win = 1'b0;
		if (GirlX >=293*2 && GirlX <= 300*2 && GirlY <=50*2)
			girl_win = 1'b1;
		else
			girl_win = 1'b0;
	end
	
	always_ff @ (posedge Reset or posedge frame_clk )
	begin
      if (Reset) begin
			Win <= 1'b0;
			Lose <= 1'b0;
		end
		else if ((boy_dead || girl_dead) == 1)
			Lose <= 1'b1;
		else if ((boy_win && girl_win) == 1)
			Win <= 1'b1;
	end
	
	assign win = Win;
	assign lose = Lose;
	
endmodule
	