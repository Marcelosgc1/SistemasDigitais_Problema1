module matriz_escalar(data_escalar, matriz_a, matriz_resultante);
    input [7:0] data_escalar; // Escalar de multiplicação
    input [199:0] matriz_a; // Matriz de entrada (25 elementos de 8 bits)
    output wire [199:0] matriz_resultante; // Matriz resultante

    genvar i;

    generate 
        for (i = 0; i < 25; i = i + 1) begin : escalar_matrizes
            assign matriz_resultante[i*8 +: 8] = data_escalar * matriz_a[i*8+: 8]; // Multiplica cada elemento pelo escalar
        end
    endgenerate

endmodule