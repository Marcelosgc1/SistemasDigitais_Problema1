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
	wire [7:0] determinante5x5, determinante4x4, determinante3x3, determinante2x2;
	reg start_multiplicacao,start_determinante;
	wire done_determinante, done_multiplicacao, done_transposta; 
	
	
	matriz_soma(matrizA, matrizB, soma);
	matriz_subtracao(matrizA, matrizB, subtracao);
	matriz_multi(matrizA, matrizB, clk, start, multiplicacao, done_multiplicacao);
	matriz_transposta(matrizA, matrizB, transposta);
	matriz_oposta(matrizA,matrizB,oposta);
	matriz_escalar(data_escalar, matrizA, escalar);
	
	matriz_determ2x2(matrizA, clk, determinante2x2);
	matriz_determ3x3(matrizA, clk, determinante3x3);
	matriz_determ4x4(matrizA,clk,start,done4x4,determinante4x4);
	matriz_determ5x5(matrizA,clk,start,done5x5,determinante5x5);
	

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
			
			
				// Determinante 2x2
				4'b1001: begin
					matriz_resultante <= determinante2x2;
					done <= 1;
				end
			
				// Determinante 3x3
				4'b1010: begin 
					matriz_resultante <= determinante3x3;
					done <= 1;
				end
			
			
				// Determinante 4x4
				4'b1011: begin
					matriz_resultante <= determinante4x4;
					done <= done4x4;
				end
				
				
				// Determinante 5x5
				4'b1100: begin
					matriz_resultante <= determinante5x5;
					done <= done5x5;
				end
				
				
				default: begin
					done <= 1;
				end 
				
			endcase 
		end
	end 



endmodule   
