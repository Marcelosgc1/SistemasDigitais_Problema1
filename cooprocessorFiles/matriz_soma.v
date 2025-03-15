module matriz_soma(
	input clk,
	input [7:0] q_a,
	input [7:0] q_b,
	output reg [7:0] data_c
);

	always @(posedge clk) begin
		data_c <= q_a + q_b;	
	end
	
endmodule