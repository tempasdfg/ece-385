/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module boy_rightup
(
	input [10:0] pixel_addr,
	input Clk,
	output logic [2:0] data_Out
);

	logic [2:0] mem [0:36*35-1];

	initial
	begin
		$readmemh("boy_rightup.txt", mem);
	end
	
	always_ff @ (posedge Clk) begin
		data_Out <= mem[pixel_addr];
	end

endmodule
