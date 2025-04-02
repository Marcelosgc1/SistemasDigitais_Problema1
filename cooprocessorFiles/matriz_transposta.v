module matriz_transposta(clk, start_transposta, matrizA, matrizB, matriz_resultante, done_transposta);
	input clk, start_transposta;
	input [199:0] matrizA;
	input [199:0] matrizB;
	output reg [199:0] matriz_resultante;
	output reg done_transposta; 
	
	integer i,j;
	
	always @(posedge clk) begin
		if(start_transposta) begin
			for (j = 0; j < 5; j = j + 1) begin : linha
					for (i = 0; i < 5; i = i + 1) begin : coluna
						assign matriz_resultante[(8*i)+(40*j)+:8] = matrizA[(40*i)+(8*j) +:8];
					end
				end
				done_transposta <= 1;
		end 
	end


endmodule 