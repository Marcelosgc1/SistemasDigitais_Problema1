module matriz_multi (clk, start_multiplicacao, matriz_a, matriz_b, matriz_resultante, done_multiplicacao);
	input clk;
	input start_multiplicacao;
	input [199:0] matriz_a;
	input [199:0] matriz_b;
	output reg [199:0] matriz_resultante;
	output reg done_multiplicacao;

    reg [7:0] linha;
	 
    integer i, j;

    function integer indice;
        input integer linha, coluna;
        indice = 8 * (coluna + 5 * linha);
    endfunction

	always @(posedge clk) begin
		if (!start_multiplicacao) begin
			matriz_resultante = 0;
			done_multiplicacao = 0;
			linha = 0;
		end else if (start_multiplicacao & !done_multiplicacao) begin
			for (j = 0; j < 5; j = j + 1) begin
				matriz_resultante[indice(linha, j) +: 8] = 0;
				for (i = 0; i < 5; i = i + 1) begin
					matriz_resultante[indice(linha, j) +: 8] = matriz_resultante[indice(linha, j) +: 8] +
					(matriz_a[indice(linha, i) +: 8] * matriz_b[indice(i, j) +: 8]);
				end
			end

			if (linha == 4) begin
				done_multiplicacao = 1;
			end else begin
				linha = linha + 1;
			end
		end
	end
endmodule