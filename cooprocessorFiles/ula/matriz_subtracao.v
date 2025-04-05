module matriz_subtracao(matrizA, matrizB, matriz_resultante);
	input [199:0] matrizA;
	input [199:0] matrizB;
	output wire [199:0] matriz_resultante;
	
	genvar i;
	
	generate
		for (i = 0; i < 25; i = i + 1) begin : subtracao_matrizes
			assign matriz_resultante[i*8 +: 8] = matrizA[i*8 +: 8] - matrizB[i*8 +: 8];
		end
		
	endgenerate



endmodule 