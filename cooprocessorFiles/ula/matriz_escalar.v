module matriz_escalar(data_escalar, matriz_a, matriz_resultante);
	input [7:0] data_escalar;
	input [199:0] matriz_a;
	output wire [199:0] matriz_resultante;

	genvar i;
	
	generate 
		for (i = 0; i < 25; i = i + 1) begin : escalar_matrizes
				assign matriz_resultante[i*8 +: 8] = data_escalar * matriz_a[i*8+: 8];
		end
	endgenerate
	

endmodule 
