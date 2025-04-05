module matriz_determ2x2(
	 input wire [199:0] matriz_A,
    input clk,
    output wire [7:0] det
);

	wire [7:0] mat [4:0][4:0];
	genvar i, j;
	
	generate begin
        for (i = 0; i < 5; i = i + 1) begin : adad
            for (j = 0; j < 5; j = j + 1) begin : asdasd
                assign mat[i][j] = matriz_A[(i * 40) + (j * 8) +: 8];
			end end end
	 endgenerate
	 
	 assign det = (mat[0][0] * mat[1][1]) - (mat[1][0] * mat[0][1]);

	// a b c
	// d e f
	// g h i
	 
	 
endmodule 