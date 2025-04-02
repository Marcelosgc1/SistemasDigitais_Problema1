module alu(
	input wire clk	,
	input wire [3:0] opcode,
	input wire [7:0] data_escalar,
	input wire [199:0] matrizA,
	input wire [199:0] matrizB,
	input wire start,
	output reg [199:0] matriz_resultante,
	output reg done
);
	
	reg signed [7:0] A [4:0][4:0];
	reg signed [7:0] B [4:0][4:0];
	reg signed [7:0] C [4:0][4:0];
	reg [199:0] soma, subtracao, multiplicacao, transposta;
	reg clkDeterminante;
	reg [24:0] equacaoA;
	reg [7:0] linha;
	reg start_soma, start_subtracao, start_multiplicacao, start_multiplicacao_escalar, start_transposta, start_oposta, start_determinante;
	reg done_soma, done_subtracao, done_multiplicacao, done_multiplicacao_escalar, done_transposta, done_oposta, done_determinante; 
	
	integer i, j, k;
	
	
	function integer indice;
        	input integer linha, coluna;
        	indice = 8 * (coluna + 5 * linha);
   endfunction
	
	matriz_soma(matrizA, matrizB, soma);
	matriz_subtracao(matrizA, matrizB, subtracao);
	matriz_multiplicacao(clk, start, matrizA, matrizB, multiplicacao, done_multiplicacao);
	matriz_transposta(clk, start, matrizA, matrizB, transposta, done_transposta);
	

	always @(posedge clk) begin
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                A[i][j] = matrizA[(i*5 + j)*8 +: 8];
                B[i][j] = matrizB[(i*5 + j)*8 +: 8];
            end
        end

	
		case(opcode)
	
			// Soma
			4'b0011: begin				 
				matriz_resultante <= soma;
				done <= 1;
			end
			
			
			// Subtração
			4'b0100: begin
				matriz_resultante <= subtracao;
				done <= 1;
			end
			
			
			// Multiplicação
			4'b0101: begin        
				matriz_resultante <= multiplicacao;
				done <= done_multiplicacao;
			end 
			
			// Transposta
			4'b0110: begin
				matriz_resultante <= transposta;
				done <= 1;
			end
			
			// Matriz oposta
			4'b0111: begin
				for (i = 0; i < 256; i = i + 8) begin : oposta_matriz
					reg signed [7:0] q_a = matrizA[i +: 8];  
					assign matriz_resultante[i +: 8] = -q_a;
				end
				done <= 1;
			end 
			
			
			// Multiplicação escalar
			4'b1000: begin
				for (i = 0; i < 256; i = i + 8) begin : subtracao_matrizes
					assign matriz_resultante[i+7 +: 8] = data_escalar * matrizA[i+7 +: 8];
				end
				done <= 1;
			end 
			
			// Determinante 2x2
			4'b1001: begin
				assign matriz_resultante = (matrizA[7:0] * matrizA[31:24]) - (matrizA[15:8] - matrizA[23:16]); 
				done <= 1;
			end
			
			// Determinante 3x3
			4'b1010: begin 
			
				// Dois pulsos de clock para fazer a operação 
				/* 
				if(!clkDeterminante) begin
					assign equacaoA = (matrizA[7:0]*matrizA[39:32]*matrizA[71:64]) + (matrizA[15:8]*matrizA[47:40]*matrizA[55:48]) + (matrizA[23:16]*matrizA[31:24]*matrizA[63:56]) 					
				end else begin
					assign matriz_resultante = equacaoA - ((matrizA[15:8]*matrizA[31:24]*matrizA[71:64]) + (matrizA[7:0]*matrizA[47:40]*matrizA[63:56]) + (matrizA[23:16]*matrizA[39:32]*matrizA[55:48]));
					clkDeterminante <= 0;
					done <= 1;
				end 
					clkDeterminante <= 1;
				*/
				
				// Um pulso de clock para fazer a operação
				assign matriz_resultante = (matrizA[7:0]*matrizA[39:32]*matrizA[71:64]) + (matrizA[15:8]*matrizA[47:40]*matrizA[55:48]) + (matrizA[23:16]*matrizA[31:24]*matrizA[63:56]) 
					- ((matrizA[15:8]*matrizA[31:24]*matrizA[71:64]) + (matrizA[7:0]*matrizA[47:40]*matrizA[63:56]) + (matrizA[23:16]*matrizA[39:32]*matrizA[55:48]));
					done <= 1; 
			end
			
			// Determinante 4x4
			4'b1011: begin
				done <= 1;
			end
			
			// Determinante 5x5
			4'b1100: begin
				done <= 1;
			end

			default: begin
				done <= 0;
			end 
			
		endcase 
	end 



endmodule   