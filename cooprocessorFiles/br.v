module br(
	input done,
	input [15:0] data_out,
	input [4:0]adrs,
	output reg [199:0] matrix_A,
	output reg [199:0] matrix_B
);

	reg [3:0]num;
	always @(posedge done) begin
		num <= adrs[3:0];
		case (adrs[4])
			0: matrix_B[num * 16 +:16] <= data_out;
			1: matrix_A[num * 16 +:16] <= data_out;
		endcase
	end




endmodule