/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module background
(
	input [16:0] pixel_addr,
	input Clk,
	output logic [3:0] data_Out
);

	logic [3:0] mem [0:320*238-1];

	initial
	begin
		$readmemh("background.txt", mem);
	end
	
	always_ff @ (posedge Clk) begin
		data_Out <= mem[pixel_addr];
	end

endmodule
