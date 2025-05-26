//MULTIPLICAÇAO 20 ADP BLOCK

module matriz_multi (
  input signed [199:0] matriz_a, // Matriz A (5x5, 8 bits por elemento)
  input signed [199:0] matriz_b, // Matriz B (5x5, 8 bits por elemento)
  input [1:0] seletor,
  input clock,
  input wire start,
  output [199:0] result, // Resultado da multiplicação
  output reg done // Sinal de conclusão
);

parameter zero = 8'b00000000;

wire [199:0] matriz_c, matriz_d, aux_kernel, tempSum;
wire [199:0] r1, r2, absSum;
	
matriz_transposta(matriz_b,, matriz_c);
assign matriz_d = {matriz_b[8+:8],matriz_b[48+:8],zero,zero,zero,matriz_b[0+:8],matriz_b[40+:8]};

assign aux_kernel = seletor[0] ? matriz_d : matriz_c;

matriz_conv uni_mtr(matriz_a, matriz_b, r1);

matriz_conv transp(matriz_a, aux_kernel, r2);



assign tempSum = r1 + r2;

assign overflow = |(tempSum[199:8]);
	
assign absSum = overflow ? 200'hff : tempSum[7:0];

assign result = seletor[1] ? absSum : r1;

//SELETOR:
//
//0X = 1 matriz
//10 = tipo sobel, 2 kernel transposta
//11 = tipo roberts, 2 kernel 45 graus




always @ (posedge clock) begin

	done <= 1;

end

		
	 
endmodule