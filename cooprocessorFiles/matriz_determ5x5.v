//Determiannte 5x5

//Determinante 5x5

module matriz_determ5x5 (
	input wire [199:0] matriz_A, 
	input clk,
	output reg [31:0] det
	
);

	reg [7:0] mat [4:0][4:0]; 
	integer i, j;
	
	function [31:0] det_4x4;
		input [7:0] a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
		begin
			det_4x4 = a * det_3x3(e, f, g, j, k, l, n, o, p) - 
						 b * det_3x3(d, f, g, i, k, l, m, o, p) + 
						 c * det_3x3(d, e, g, i, j, l, m, n, p) - 
						 d * det_3x3(d, e, f, i, j, k, m, n, o);
		end
	endfunction

	function [31:0] det_3x3;
		input [7:0] a, b, c, d, e, f, g, h, i;
		begin
			det_3x3 = a * (e * i - f * h) - 
						 b * (d * i - f * g) + 
						 c * (d * h - e * g);
		end
	endfunction

	always @(posedge clk) begin
		for (i = 0; i < 5; i = i + 1) begin
			for (j = 0; j < 5; j = j + 1) begin
				mat[i][j] = matriz_A[(i * 40) + (j * 8) +: 8];
			end
		end

		det = 
			 mat[0][0] * det_4x4(mat[1][1], mat[1][2], mat[1][3], mat[1][4], mat[2][1], mat[2][2], mat[2][3], mat[2][4], mat[3][1], mat[3][2], mat[3][3], mat[3][4], mat[4][1], mat[4][2], mat[4][3], mat[4][4]) -
			 mat[0][1] * det_4x4(mat[1][0], mat[1][2], mat[1][3], mat[1][4], mat[2][0], mat[2][2], mat[2][3], mat[2][4], mat[3][0], mat[3][2], mat[3][3], mat[3][4], mat[4][0], mat[4][2], mat[4][3], mat[4][4]) +
			 mat[0][2] * det_4x4(mat[1][0], mat[1][1], mat[1][3], mat[1][4], mat[2][0], mat[2][1], mat[2][3], mat[2][4], mat[3][0], mat[3][1], mat[3][3], mat[3][4], mat[4][0], mat[4][1], mat[4][3], mat[4][4]) -
			 mat[0][3] * det_4x4(mat[1][0], mat[1][1], mat[1][2], mat[1][4], mat[2][0], mat[2][1], mat[2][2], mat[2][4], mat[3][0], mat[3][1], mat[3][2], mat[3][4], mat[4][0], mat[4][1], mat[4][2], mat[4][4]) +
			 mat[0][4] * det_4x4(mat[1][0], mat[1][1], mat[1][2], mat[1][3], mat[2][0], mat[2][1], mat[2][2], mat[2][3], mat[3][0], mat[3][1], mat[3][2], mat[3][3], mat[4][0], mat[4][1], mat[4][2], mat[4][3]);
	end	
endmodule
