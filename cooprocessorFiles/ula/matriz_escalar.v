module matriz_escalar(data_escalar, matriz_a, matriz_resultante, overflow);
    input [7:0] data_escalar; // Escalar de multiplicação
    input [199:0] matriz_a; // Matriz de entrada (25 elementos de 8 bits)
    output wire [199:0] matriz_resultante; // Matriz resultante
	 output wire overflow;
	 
	 wire [399:0] temp_resul;
	 wire [24:0] temp;
    genvar i;

    generate 
        for (i = 0; i < 25; i = i + 1) begin : escalar_matrizes
				assign temp_resul[i*16+:16] = data_escalar * matriz_a[i*8+: 8];
            assign matriz_resultante[i*8 +: 8] = temp_resul[i*16+:8]; // Multiplica cada elemento pelo escalar
				
				assign temp[i] = !(!(|temp_resul[i*16 + 7 +:9]) | (&temp_resul[i*16 + 7 +:9]));
        end
    endgenerate
	 
	 assign overflow = |temp;

endmodule