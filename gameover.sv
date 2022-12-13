/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module gameover
(
	input [11:0] pixel_addr,
	input Clk,
	output logic [1:0] data_Out
);

	logic [1:0] mem [0:100*32-1];

	initial
	begin
		$readmemh("gameover.txt", mem);
	end
	
	always_ff @ (posedge Clk) begin
		data_Out <= mem[pixel_addr];
	end

endmodule
