module br(
	input done,
	input [15:0] data_in,
	input [5:0]adrs,
	input [199:0] matrix_C,
	output reg [199:0] matrix_A,
	output reg [199:0] matrix_B,
	output reg [15:0] data_out
);

	reg [3:0]num;
	always @(posedge done) begin
		num <= adrs[3:0];
		case (adrs[5:4])
			0: matrix_B[num * 16 +:16] <= data_in;
			1: matrix_A[num * 16 +:16] <= data_in;
			2: data_out <= matrix_C[num * 16 +:16];
		endcase
	end




endmodule