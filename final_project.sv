//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module final_project (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, boyxsig, boyysig, girlxsig, girlysig, Board_y_X, Board_y_Y, Board_p_X, Board_p_Y;
	logic [9:0] Box_X, Box_Y;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode0, keycode1, keycode2, keycode3;
	logic boy_left, boy_right, boy_up, girl_left, girl_right, girl_up, Reset, win, lose;
	logic [3:0] boy_status, girl_status;
	logic is_up, is_down, is_stuck;
	logic r1, r2, r3, b1, b2, b3, b4;
	logic [2:0] diamond_r_counter, diamond_b_counter;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
//	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
//	assign HEX4[7] = 1'b1;
//	
//	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
//	assign HEX3[7] = 1'b1;
//	
//	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
//	assign HEX1[7] = 1'b1;
//	
//	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
//	assign HEX0[7] = 1'b1;

	HexDriver hex_driver4 ({1'b0, diamond_r_counter}, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver2 ({1'b0, diamond_b_counter}, HEX2[6:0]);
	assign HEX2[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
//	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
//	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	assign HEX0 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX1 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	assign HEX3 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX5 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	//Assign one button to reset

	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	final_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode0_export(keycode0),
		.keycode1_export(keycode1),
		.keycode2_export(keycode2),
		.keycode3_export(keycode3)
		
	 );


//instantiate a vga_controller, ball, and color_mapper here with the ports.
	key_select key(.keycode0(keycode0),
					.keycode1(keycode1),
					.keycode2(keycode2),
					.keycode3(keycode3),
					.Clk(VGA_Clk),
					.boy_left(boy_left),
					.boy_right(boy_right),
					.boy_up(boy_up),
					.girl_left(girl_left),
					.girl_right(girl_right),
					.girl_up(girl_up),
					.Reset(Reset)
	);
					
	color_mapper CM(
		.BoyX(boyxsig),
		.BoyY(boyysig),
		.GirlX(girlxsig), 
		.GirlY(girlysig),
		.DrawX(drawxsig),
		.DrawY(drawysig),
		.Board_y_X(Board_y_X),
		.Board_y_Y(Board_y_Y),
		.Board_p_X(Board_p_X),
		.Board_p_Y(Board_p_Y),
		.Box_X(Box_X),
		.Box_Y(Box_Y),
		.boy_status(boy_status),
		.girl_status(girl_status),
		.win(win),
		.lose(lose),
		.diamond_r1(r1),
		.diamond_r2(r2),
		.diamond_r3(r3),
		.diamond_b1(b1),
		.diamond_b2(b2),
		.diamond_b3(b3),
		.diamond_b4(b4),
		.Clk(VGA_Clk),
      .Red(Red),
		.Green(Green),
		.Blue(Blue)
	);

	boy_move BO(
		.Reset(Reset_h), 
		.frame_clk(VGA_VS),
		.win(win),
		.lose(lose),
		.boy_left(boy_left),
		.boy_right(boy_right),
		.boy_up(boy_up),
		.board_p_up(is_up),
		.board_p_down(is_down),
		.box_stuck(is_stuck),
		.Board_y_X(Board_y_X),
		.Board_y_Y(Board_y_Y),
		.Board_p_X(Board_p_X),
		.Board_p_Y(Board_p_Y),
		.BoxX(Box_X),
		.BoxY(Box_Y),
      .BoyX(boyxsig), 
		.BoyY(boyysig),
		.boy_status(boy_status)
	);
	
	girl_move GI(
		.Reset(Reset_h), 
		.frame_clk(VGA_VS),
		.win(win),
		.lose(lose),
		.girl_left(girl_left),
		.girl_right(girl_right),
		.girl_up(girl_up),
		.board_p_up(is_up),
		.board_p_down(is_down),
		.box_stuck(is_stuck),
		.Board_y_X(Board_y_X),
		.Board_y_Y(Board_y_Y),
		.Board_p_X(Board_p_X),
		.Board_p_Y(Board_p_Y),
		.BoxX(Box_X),
		.BoxY(Box_Y),
      .GirlX(girlxsig), 
		.GirlY(girlysig),
		.girl_status(girl_status)
	);
	
	board_y_move BY(
		 .Reset(Reset_h),
		 .frame_clk(VGA_VS),
		 .BoyX(boyxsig),
		 .BoyY(boyysig),
		 .GirlX(girlxsig), 
		 .GirlY(girlysig),
		 .BoardX(Board_y_X),
		 .BoardY(Board_y_Y)
	);
	
	box_move BM(
		.Reset(Reset_h),
		.frame_clk(VGA_VS),
		.boy_status(boy_status),
		.girl_status(girl_status), 
		.BoyX(boyxsig),
		.BoyY(boyysig),
		.GirlX(girlxsig),
		.GirlY(girlysig),
		.BoxX(Box_X),
		.BoxY(Box_Y),
		.is_stuck(is_stuck)
	);
	
	board_p_move BP(
		 .Reset(Reset_h),
		 .frame_clk(VGA_VS),
		 .BoyX(boyxsig),
		 .BoyY(boyysig),
		 .GirlX(girlxsig), 
		 .GirlY(girlysig),
		 .BoardX(Board_p_X),
		 .BoardY(Board_p_Y),
		 .is_up(is_up),
		 .is_down(is_down)
	);
	
	diamond DI(.Reset(Reset_h),
				  .frame_clk(VGA_VS),
				  .BoyX(boyxsig),
				  .BoyY(boyysig),
				  .GirlX(girlxsig),
				  .GirlY(girlysig),
				  .gain_r1(r1),
				  .gain_r2(r2),
				  .gain_r3(r3),
				  .gain_b1(b1),
				  .gain_b2(b2),
				  .gain_b3(b3),
				  .gain_b4(b4),
				  .red(diamond_r_counter),
				  .blue(diamond_b_counter)
	);
	
	win_or_lose (
		.Reset(Reset_h),
		.frame_clk(VGA_VS),
		.BoyX(boyxsig),
		.BoyY(boyysig),
		.GirlX(girlxsig),
		.GirlY(girlysig),
		.win(win),
		.lose(lose)
	);
	
	vga_controller VC(
		.Clk(MAX10_CLK1_50),
      .Reset(Reset_h),
      .hs(VGA_HS),
		.vs(VGA_VS),
		.pixel_clk(VGA_Clk),
		.blank(blank),
		.sync(sync),
		.DrawX(drawxsig),
		.DrawY(drawysig)
	);
endmodule
