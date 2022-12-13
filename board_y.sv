/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module board_y
(
	input [7:0] pixel_addr,
	input Clk,
	output logic data_Out
);

	logic mem [0:32*7-1];

	initial
	begin
		$readmemb("board_y.txt", mem);
	end
	
	always_ff @ (posedge Clk) begin
		data_Out <= mem[pixel_addr];
	end

endmodule
