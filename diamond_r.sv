/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module diamond_r
(
	input [8:0] pixel_addr,
	input Clk,
	output logic [2:0] data_Out
);

	logic [2:0] mem [0:20*16-1];

	initial
	begin
		$readmemh("diamond_r.txt", mem);
	end
	
	always_ff @ (posedge Clk) begin
		data_Out <= mem[pixel_addr];
	end

endmodule
