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
	wire [199:0] soma, subtracao, multiplicacao, transposta,oposta,escalar;
	wire [7:0] determinante4x4;
	reg start_multiplicacao,start_determinante;
	wire done_determinante, done_multiplicacao, done_transposta; 
	
	
	
	matriz_soma(matrizA, matrizB, soma);
	matriz_subtracao(matrizA, matrizB, subtracao);
	matriz_multi(matrizA, matrizB, clk, start, multiplicacao, done_multiplicacao);
	matriz_transposta(matrizA, matrizB, transposta);
	matriz_oposta(matrizA,matrizB,oposta);
	matriz_determ4x4(matrizA,clk,start,done4x4,determinante4x4);
	matriz_escalar(data_escalar, matrizA, escalar);

	always @(posedge clk) begin
		if (!start) begin
			done = 0;
		end else
	 
		if(start & !done) begin
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
					matriz_resultante <= oposta;
					done <= 1;
				end 
				
				
			
			
			
				// Multiplicação escalar
				4'b1000: begin
					matriz_resultante <= escalar;
					done <= 1;
				end 
			
			/*
			// Determinante 2x2
			4'b1001: begin
				assign matriz_resultante = (matrizA[7:0] * matrizA[31:24]) - (matrizA[15:8] - matrizA[23:16]); 
				done <= 1;
			end
			
			// Determinante 3x3
			4'b1010: begin 
			
				// Dois pulsos de clock para fazer a operação 
				
				if(!clkDeterminante) begin
					assign equacaoA = (matrizA[7:0]*matrizA[39:32]*matrizA[71:64]) + (matrizA[15:8]*matrizA[47:40]*matrizA[55:48]) + (matrizA[23:16]*matrizA[31:24]*matrizA[63:56]) 					
				end else begin
					assign matriz_resultante = equacaoA - ((matrizA[15:8]*matrizA[31:24]*matrizA[71:64]) + (matrizA[7:0]*matrizA[47:40]*matrizA[63:56]) + (matrizA[23:16]*matrizA[39:32]*matrizA[55:48]));
					clkDeterminante <= 0;
					done <= 1;
				end 
					clkDeterminante <= 1;
				
				
				// Um pulso de clock para fazer a operação
				assign matriz_resultante = (matrizA[7:0]*matrizA[39:32]*matrizA[71:64]) + (matrizA[15:8]*matrizA[47:40]*matrizA[55:48]) + (matrizA[23:16]*matrizA[31:24]*matrizA[63:56]) 
					- ((matrizA[15:8]*matrizA[31:24]*matrizA[71:64]) + (matrizA[7:0]*matrizA[47:40]*matrizA[63:56]) + (matrizA[23:16]*matrizA[39:32]*matrizA[55:48]));
					done <= 1; 
			end
			*/
			
				// Determinante 4x4
				4'b1011: begin
					matriz_resultante <= determinante4x4;
					done <= done4x4;
				end
				
				/*
				// Determinante 5x5
				4'b1100: begin
					done <= 1;
				end
				*/
				
				default: begin
					done <= 1;
				end 
				
			endcase 
		end
	end 



endmodule   
