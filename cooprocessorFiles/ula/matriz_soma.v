module matriz_soma(matrizA, matrizB, matriz_resultante);
	input [199:0] matrizA; // Primeira matriz de entrada
	input [199:0] matrizB; // Segunda matriz de entrada
	output wire [199:0] matriz_resultante; // Saída da soma das matrizes
	
	genvar i;
	
	generate
		for (i = 0; i < 25; i = i + 1) begin : soma_matrizes
			assign matriz_resultante[i*8 +: 8] = matrizA[i*8 +: 8] + matrizB[i*8 +: 8]; // Soma elemento a elemento
		end
	endgenerate
	
	
	
endmodule