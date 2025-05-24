//MULTIPLICAÇAO 20 ADP BLOCK

module matriz_multi (
  input signed [199:0] matriz_a, // Matriz A (5x5, 8 bits por elemento)
  input signed [199:0] matriz_b, // Matriz B (5x5, 8 bits por elemento)
  input clock,
  input wire start,
  output [199:0] result, // Resultado da multiplicação
  output reg done // Sinal de conclusão
);
	
	wire [400:0] matriz_resultante;
	wire [199:0] convolution, modulo, to_positive;
	

	
	always @ (posedge clock) begin
		done <= 1;
	end
	
	
//	convolution algorithm:
//	
//	escalar multi
// soma results
// conv pronto!
//
// verifica se eh negativo
//
//
//


    genvar i;

    generate
        for (i = 0; i < 25; i = i + 1) begin : escalar_matrizes
            assign matriz_resultante[i*16 +: 16] = matriz_b[i*8+: 8] * {1'b0, matriz_a[i*8+: 8]}; // Multiplica cada elemento pelo escalar
        end
    endgenerate

	assign convolution =
      $signed(matriz_resultante[0*16 +: 16])  + $signed(matriz_resultante[1*16 +: 16]) +
      $signed(matriz_resultante[2*16 +: 16])  + $signed(matriz_resultante[3*16 +: 16]) +
      $signed(matriz_resultante[4*16 +: 16])  + $signed(matriz_resultante[5*16 +: 16]) +
      $signed(matriz_resultante[6*16 +: 16])  + $signed(matriz_resultante[7*16 +: 16]) +
      $signed(matriz_resultante[8*16 +: 16])  + $signed(matriz_resultante[9*16 +: 16]) +
      $signed(matriz_resultante[10*16 +: 16]) + $signed(matriz_resultante[11*16 +: 16]) +
      $signed(matriz_resultante[12*16 +: 16]) + $signed(matriz_resultante[13*16 +: 16]) +
      $signed(matriz_resultante[14*16 +: 16]) + $signed(matriz_resultante[15*16 +: 16]) +
      $signed(matriz_resultante[16*16 +: 16]) + $signed(matriz_resultante[17*16 +: 16]) +
      $signed(matriz_resultante[18*16 +: 16]) + $signed(matriz_resultante[19*16 +: 16]) +
      $signed(matriz_resultante[20*16 +: 16]) + $signed(matriz_resultante[21*16 +: 16]) +
      $signed(matriz_resultante[22*16 +: 16]) + $signed(matriz_resultante[23*16 +: 16]) +
      $signed(matriz_resultante[24*16 +: 16]);
		
		
		

	assign to_positive = ~convolution + 1'b1;
		
	assign modulo = convolution[199] ? to_positive : convolution;
		
		
		
		

		
		
	
	assign overflow = |(modulo[199:8]);
	//nor(overflow, t0, t1);
	
	assign result = {overflow, modulo[7:0]};
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	 
endmodule