module matriz_transposta(clk, matrizA, matrizB, matriz_resultante);
	input clk;
	input [199:0] matrizA;
	input [199:0] matrizB;
	output wire [199:0] matriz_resultante;
	
	genvar i,j;
	
	generate
		for (j = 0; j < 5; j = j + 1) begin : linha
			for (i = 0; i < 5; i = i + 1) begin : coluna
				assign matriz_resultante[(8*i)+(40*j)+:8] = matrizA[(40*i)+(8*j) +:8];
			end
		end
	endgenerate

endmodule 