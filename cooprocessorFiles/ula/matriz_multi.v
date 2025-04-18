//MULTIPLICAÇAO 20 ADP BLOCK

module matriz_multi (
  input signed [199:0] matriz_a, // Matriz A (5x5, 8 bits por elemento)
  input signed [199:0] matriz_b, // Matriz B (5x5, 8 bits por elemento)
  input clock,
  input wire start,
  output reg signed [199:0] matriz_c = 0, // Resultado da multiplicação
  output reg done, // Sinal de conclusão
  output reg overflow
);

	reg [2:0] linha = 0; // Índice da linha atual
	reg signed [20:0] temp [0:4]; // Armazena resultado parcial da linha
	wire [4:0] temp_over;
	
	genvar j;
	
	generate
		for (j = 0; j<5; j=j+1) begin : overflow_signal
			assign temp_over[j] = !(!(|temp[j][7+:14]) | (&temp[j][7+:14]));
		end
	endgenerate
	
	assign linha_overflow = |temp_over;
	
	
	always @(posedge clock) begin
		 if(start) begin
		 
		 
			 integer i;
			 for (i = 0; i < 5; i = i + 1) begin
					  temp[i] = (matriz_a[(linha * 40) + 7 -: 8]   * matriz_b[(i * 8) +: 8]) +
									(matriz_a[(linha * 40) + 15 -: 8]  * matriz_b[(i * 8) + 40 +: 8]) +
									(matriz_a[(linha * 40) + 23 -: 8]  * matriz_b[(i * 8) + 80 +: 8]) +
									(matriz_a[(linha * 40) + 31 -: 8]  * matriz_b[(i * 8) + 120 +: 8]) +
									(matriz_a[(linha * 40) + 39 -: 8]  * matriz_b[(i * 8) + 160 +: 8]);
			 end
			 
			 overflow <= overflow | linha_overflow;
			 for (i = 0; i < 5; i = i + 1) begin
				  matriz_c[(linha * 40) + (i * 8) + 7 -: 8] <= temp[i][7:0]; // Atribui resultado à matriz C
			 end

			 if (linha == 4) begin
				  linha <= 0;
				  done <= 1; // Fim da multiplicação
			 end else begin
				  linha <= linha + 1;
				  done <= 0;
			 end
		end else begin
			 done <= 0;
			 overflow <= 0;
		end
	end

endmodule