module matriz_soma(matrizA, matrizB, matriz_resultante, overflow);
	input [199:0] matrizA; // Primeira matriz de entrada
	input [199:0] matrizB; // Segunda matriz de entrada
	output wire [199:0] matriz_resultante; // Saída da soma das matrizes
	output wire overflow; //sinal de overflow
	wire [24:0] temp;
	genvar i;
	
	generate
		for (i = 0; i < 25; i = i + 1) begin : soma_matrizes
			assign matriz_resultante[i*8 +: 8] = matrizA[i*8 +: 8] + matrizB[i*8 +: 8]; // Soma elemento a elemento
		end
	endgenerate
	assign overflow = (!(matrizA[7] ^ matrizB[7]) & (matrizA[7] ^ matriz_resultante[7])) |
							(!(matrizA[14] ^ matrizB[14]) & (matrizA[14] ^ matriz_resultante[14])) |
							(!(matrizA[21] ^ matrizB[21]) & (matrizA[21] ^ matriz_resultante[21])) |
							(!(matrizA[28] ^ matrizB[28]) & (matrizA[28] ^ matriz_resultante[28])) |
							(!(matrizA[35] ^ matrizB[35]) & (matrizA[35] ^ matriz_resultante[35])) |
							(!(matrizA[42] ^ matrizB[42]) & (matrizA[42] ^ matriz_resultante[42])) |
							(!(matrizA[49] ^ matrizB[49]) & (matrizA[49] ^ matriz_resultante[49])) |
							(!(matrizA[56] ^ matrizB[56]) & (matrizA[56] ^ matriz_resultante[56])) |
							(!(matrizA[63] ^ matrizB[63]) & (matrizA[63] ^ matriz_resultante[63])) |
							(!(matrizA[70] ^ matrizB[70]) & (matrizA[70] ^ matriz_resultante[70])) |
							(!(matrizA[77] ^ matrizB[77]) & (matrizA[77] ^ matriz_resultante[77])) |
							(!(matrizA[84] ^ matrizB[84]) & (matrizA[84] ^ matriz_resultante[84])) |
							(!(matrizA[91] ^ matrizB[91]) & (matrizA[91] ^ matriz_resultante[91])) |
							(!(matrizA[98] ^ matrizB[98]) & (matrizA[98] ^ matriz_resultante[98])) |
							(!(matrizA[105] ^ matrizB[105]) & (matrizA[105] ^ matriz_resultante[105])) |
							(!(matrizA[112] ^ matrizB[112]) & (matrizA[112] ^ matriz_resultante[112])) |
							(!(matrizA[119] ^ matrizB[119]) & (matrizA[119] ^ matriz_resultante[119])) |
							(!(matrizA[126] ^ matrizB[126]) & (matrizA[126] ^ matriz_resultante[126])) |
							(!(matrizA[133] ^ matrizB[133]) & (matrizA[133] ^ matriz_resultante[133])) |
							(!(matrizA[140] ^ matrizB[140]) & (matrizA[140] ^ matriz_resultante[140])) |
							(!(matrizA[147] ^ matrizB[147]) & (matrizA[147] ^ matriz_resultante[147])) |
							(!(matrizA[154] ^ matrizB[154]) & (matrizA[154] ^ matriz_resultante[154])) |
							(!(matrizA[161] ^ matrizB[161]) & (matrizA[161] ^ matriz_resultante[161])) |
							(!(matrizA[168] ^ matrizB[168]) & (matrizA[168] ^ matriz_resultante[168])) |
							(!(matrizA[175] ^ matrizB[175]) & (matrizA[175] ^ matriz_resultante[175]));
	
	
endmodule