module matriz_soma(matrizA, matrizB, matriz_resultante);
	input [199:0] matrizA;
	input [199:0] matrizB;
	output wire [199:0] matriz_resultante;
	
	genvar i;
	
	generate
		for (i = 0; i < 256; i = i + 8) begin : subtracao_matrizes
			assign matriz_resultante[i+7 +: i] = matrizA[i+7 +: i] + matrizB[i+7 +: i];
		end
		
	endgenerate



endmodule 