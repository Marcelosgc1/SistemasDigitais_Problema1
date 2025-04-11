module matriz_transposta(matrizA, matrizB, matriz_resultante);
        input [199:0] matrizA; // Matriz original
        input [199:0] matrizB; // Não utilizado aqui
        output wire [199:0] matriz_resultante; // Matriz transposta

        genvar i,j;

        generate
                for (j = 0; j < 5; j = j + 1) begin : linha
                        for (i = 0; i < 5; i = i + 1) begin : coluna
                                assign matriz_resultante[(8*i)+(40*j)+:8] = matrizA[(40*i)+(8*j) +:8]; // Transpõe elementos
                        end
                end
        endgenerate

endmodule