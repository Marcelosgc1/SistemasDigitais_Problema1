module matriz_oposta(matrizA, matrizB, matriz_resultante);
	input [199:0] matrizA;
	input [199:0] matrizB;
	output wire [199:0] matriz_resultante;
	
	
	genvar i;
	generate 
		for (i = 0; i < 199; i = i + 8) begin : oposta_matriz
			assign matriz_resultante[i +: 8] = -matrizA[i +: 8];
		end
	endgenerate 
	

endmodule 