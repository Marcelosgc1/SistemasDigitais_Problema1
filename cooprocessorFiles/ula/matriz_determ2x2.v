module matriz_determ2x2(
    input wire [199:0] matriz_A, // Matriz 5x5 codificada como vetor linear
    input clk,
    output wire [7:0] det // Determinante 2x2
);

    wire [7:0] mat [4:0][4:0]; // Matriz 5x5 de elementos 8 bits
    genvar i, j;

    generate begin
        for (i = 0; i < 5; i = i + 1) begin : adad
            for (j = 0; j < 5; j = j + 1) begin : asdasd
                assign mat[i][j] = matriz_A[(i * 40) + (j * 8) +: 8]; // Mapeia o vetor para matriz
            end
        end
    end endgenerate

    assign det = (mat[0][0] * mat[1][1]) - (mat[1][0] * mat[0][1]); // Determinante 2x2

    // a b
    // c d

endmodule