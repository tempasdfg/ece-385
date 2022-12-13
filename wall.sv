/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module wall
(
	input [14:0] pixel_addr,
	output logic data_Out
);

	logic mem [0:160*119-1];

	initial
	begin
		$readmemb("wall.txt", mem);
	end
	
	assign data_Out = mem[pixel_addr];

endmodule
