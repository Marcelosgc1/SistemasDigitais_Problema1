module ula(
	input wire clk	,
	input wire [3:0] opcode,
	input wire [7:0] data_escalar,
	input wire [199:0] matrizA,
	input wire [199:0] matrizB,
	output reg [199:0] matriz_resultante,
	output reg done
);
	
	reg signed [7:0] A [4:0][4:0];
	reg signed [7:0] B [4:0][4:0];
	reg signed [7:0] C [4:0][4:0];

	
	integer i, j, k;

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
				for (i = 0; i < 200; i = i + 8) begin : soma_matrizes
					matriz_resultante[i +: 8] = matrizA[i +: 8] + matrizB[i +: 8];
				end
				done <= 1;
			end
			
			
			// Subtração
			4'b0100: begin
				for (i = 0; i < 200; i = i + 8) begin : subtracao_matrizes
					matriz_resultante[i +: 8] = matrizA[i +: 8] - matrizB[i +: 8];
				end
				done <= 1;
			end
			
			
			// Multiplicação
			4'b0101: begin

              for (i = 0; i < 5; i = i + 1) begin
                  for (j = 0; j < 5; j = j + 1) begin
                      for (k = 0; k < 5; k = k + 1) begin                     
                          C[i][j] = C[i][j] + (A[i][k] * B[k][j]);
                      end
                  end
              end

              for (i = 0; i < 5; i = i + 1) begin
                  for (j = 0; j < 5; j = j + 1) begin
                      matriz_resultante[8*(i*5 + j) +: 8] = C[i][j];  
                  end
              end


				done <= 1;
			end 
			
			// Transposta
			4'b0110: begin
				for (j = 0; j < 5; j = j + 1) begin : linha
					for (i = 0; i < 5; i = i + 1) begin : coluna
						matriz_resultante[(8*i)+(40*j)+:8] = matrizA[(40*i)+(8*j) +:8];
					end
				end
				done <= 1;
			end
			
			// Matriz oposta
			4'b0111: begin
				for (i = 0; i < 200; i = i + 8) begin : oposta_matriz
					matriz_resultante[i +: 8] = -matrizA[i +: 8];
				end
				done <= 1;
			end 
			
			
			// Multiplicação escalar
			4'b1000: begin
				for (i = 0; i < 200; i = i + 8) begin : subtracao_matrizes
					matriz_resultante[i +: 8] = data_escalar * matrizA[i +: 8];
				end
				done <= 1;
			end 
			
			// Determinante 2x2
			4'b1001: begin
				done <= 1;
			end
			
			// Determinante 3x3
			4'b1010: begin
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