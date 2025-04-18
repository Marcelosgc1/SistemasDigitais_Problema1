module matriz_subtracao(matrizA, matrizB, matriz_resultante, overflow);
	input [199:0] matrizA; // Primeira matriz de entrada
	input [199:0] matrizB; // Segunda matriz de entrada
	output wire [199:0] matriz_resultante; // Resultado da subtração
	output wire overflow;
	wire [24:0] temp;
	genvar i;
	
	generate
		for (i = 0; i < 25; i = i + 1) begin : subtracao_matrizes
			assign matriz_resultante[i*8 +: 8] = matrizA[i*8 +: 8] - matrizB[i*8 +: 8]; // Subtrai elemento a elemento
			assign temp[i] = ((matrizA[i*8 +7] ^ matrizB[i*8 +7]) & !(matrizA[i*8 +7] ^ matriz_resultante[i*8 +7]));
		end
	endgenerate
	assign overflow = |temp;
	
	
endmodule