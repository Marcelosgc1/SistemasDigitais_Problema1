module matriz_oposta(matrizA, matrizB, matriz_resultante);
        input [199:0] matrizA; // Matriz de entrada
        input [199:0] matrizB; // Não utilizada
        output wire [199:0] matriz_resultante; // Resultado da matriz oposta

        genvar i;
        generate 
                for (i = 0; i < 199; i = i + 8) begin : oposta_matriz
                        assign matriz_resultante[i +: 8] = -matrizA[i +: 8]; // Inverte sinal de cada elemento
                end
        endgenerate 
endmodule