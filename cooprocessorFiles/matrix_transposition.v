module matrix_transposition(
    input [255:0] q_a,
    output wire [255:0] data_c
);

	genvar i, j;
		generate
		for (j = 0; j < 5; j = j + 1) begin : linha
			for (i = 0; i < 5; i = i + 1) begin : coluna
				assign data_c[(8*i)+(40*j)+:8] = q_a[(40*i)+(8*j) +:8];
			end
		end
	endgenerate

endmodule