module matriz_determ3x3(
    input wire [199:0] matriz_A, // Matriz 5x5 em vetor linear
    input clk,
    output wire [7:0] det // Saída do determinante 3x3
);

    wire [7:0] mat [4:0][4:0]; // Matriz 5x5 com elementos de 8 bits
    genvar i, j;

    generate begin
        for (i = 0; i < 5; i = i + 1) begin : adad
            for (j = 0; j < 5; j = j + 1) begin : asdasd
                assign mat[i][j] = matriz_A[(i * 40) + (j * 8) +: 8]; // Conversão do vetor para matriz
            end
        end
    end endgenerate

    assign det = mat[0][0] * 
    (mat[1][1] * mat[2][2] - mat[1][2] * mat[2][1]) 
    - mat[0][1] * (mat[1][0] * mat[2][2] - mat[1][2] * mat[2][0]) + mat[0][2] * 
    (mat[1][0] * mat[2][1] - mat[1][1] * mat[2][0]); // Determinante 3x3

    // a b c
    // d e f
    // g h i

endmodule