module diamond( input Reset, frame_clk,
					 input [9:0] BoyX, BoyY, GirlX, GirlY,
					 output logic gain_r1, gain_r2, gain_r3, gain_b1, gain_b2, gain_b3, gain_b4,
					 output [2:0] red, blue
);

	logic [2:0] red_total, blue_total;
	logic r1, r2, r3, b1, b2, b3, b4, R1, R2, R3, B1, B2, B3, B4;
	
	parameter [9:0] red1X = 163*2;
	parameter [9:0] red1Y = 216*2;
	parameter [9:0] red2X = 54*2;
	parameter [9:0] red2Y = 106*2;
	parameter [9:0] red3X = 88*2;
	parameter [9:0] red3Y = 17*2;
	
	parameter [9:0] blue1X = 227*2;
	parameter [9:0] blue1Y = 220*2;
	parameter [9:0] blue2X = 185*2;
	parameter [9:0] blue2Y = 117*2;
	parameter [9:0] blue3X = 11*2;
	parameter [9:0] blue3Y = 43*2;
	parameter [9:0] blue4X = 188*2;
	parameter [9:0] blue4Y = 35*2;
	
	always_comb begin
		if (BoyX+20 >= red1X && BoyX <= red1X+20 && BoyY+35 >= red1Y)
			r1 = 1'b1;
		else
			r1 = 1'b0;
		if (BoyX+20 >= red2X && BoyX <= red2X+20 && BoyY+35 >= red2Y && BoyY <= red2Y)
			r2 = 1'b1;
		else
			r2 = 1'b0;
		if (BoyX+20 >= red3X && BoyX <= red3X+20 && BoyY+35 >= red3Y && BoyY <= red3Y)
			r3 = 1'b1;
		else
			r3 = 1'b0;
		if (GirlX+20 >= blue1X && GirlX <= blue1X+20 && GirlY+35 >= blue1Y)
			b1 = 1'b1;
		else
			b1 = 1'b0;
		if (GirlX+20 >= blue2X && GirlX <= blue2X+20 && GirlY+35 >= blue2Y && GirlY <= blue2Y)
			b2 = 1'b1;
		else
			b2 = 1'b0;
		if (GirlX+20 >= blue3X && GirlX <= blue3X+20 && GirlY+35 >= blue3Y && GirlY <= blue3Y)
			b3 = 1'b1;
		else
			b3 = 1'b0;
		if (GirlX+20 >= blue4X && GirlX <= blue4X+20 && GirlY+35 >= blue4Y && GirlY <= blue4Y)
			b4 = 1'b1;
		else
			b4 = 1'b0;
	end
	
	always_ff @ (posedge Reset or posedge frame_clk )
    begin
       if (Reset)
        begin 
            R1 <= 1'b0;
				R2 <= 1'b0;
				R3 <= 1'b0;
				B1 <= 1'b0;
				B2 <= 1'b0;
				B3 <= 1'b0;
				B4 <= 1'b0;
				red_total <= 3'b0;
				blue_total <= 3'b0;
        end
		 else begin
			if (r1 == 1'b1 && R1 == 1'b0) begin
				R1 <= 1'b1;
				red_total <= red_total + 1;
			end
			if (r2 == 1'b1 && R2 == 1'b0) begin
				R2 <= 1'b1;
				red_total <= red_total + 1;
			end
			if (r3 == 1'b1 && R3 == 1'b0) begin
				R3 <= 1'b1;
				red_total <= red_total + 1;
			end
			
			if (b1 == 1'b1 && B1 == 1'b0) begin
				B1 <= 1'b1;
				blue_total <= blue_total + 1;
			end
			if (b2 == 1'b1 && B2 == 1'b0) begin
				B2 <= 1'b1;
				blue_total <= blue_total + 1;
			end
			if (b3 == 1'b1 && B3 == 1'b0) begin
				B3 <= 1'b1;
				blue_total <= blue_total + 1;
			end
			if (b4 == 1'b1 && B4 == 1'b0) begin
				B4 <= 1'b1;
				blue_total <= blue_total + 1;
			end
		end
	end
	
	assign gain_r1 = R1;
	assign gain_r2 = R2;
	assign gain_r3 = R3;
	assign gain_b1 = B1;
	assign gain_b2 = B2;
	assign gain_b3 = B3;
	assign gain_b4 = B4;
	assign red = red_total;
	assign blue = blue_total;
	
endmodule
			