module matriz_escalar(clk, data_escalar, matriz_a, matriz_b, matriz_resultante);
	input clk;
	input [7:0] data_escalar;
	input [199:0] matriz_a;
	input [199:0] matriz_b;
	output wire [199:0] matriz_resultante;

	genvar i;
	
	generate 
		for (i = 0; i < 25; i = i + 1) begin : subtracao_matrizes
				assign matriz_resultante[i*8 +: 8] = data_escalar * matriz_a[i*8+: 8];
		end
	endgenerate
	

endmodule 
