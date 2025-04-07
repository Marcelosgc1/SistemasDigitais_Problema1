//banco de registradores

module br(
	input done,
	input [15:0] data_in,
	input [5:0] endereco,
	input [199:0] matrix_C,
	output reg [199:0] matrix_A,
	output reg [199:0] matrix_B,
	output reg [15:0] data_out
);

	reg [3:0] posicao;
	
	always @(posedge done) begin
		
		posicao = endereco[3:0];
		
		case (endereco[5:4])
			//salva valor de entrada em registrador da matriz A ou B
			0: matrix_A[posicao * 16 +:16] = data_in;
			1: matrix_B[posicao * 16 +:16] = data_in;
			
			//salva valor da matriz C em reg temporario, para escreve-lo na memoria
			2: data_out = matrix_C[posicao * 16 +:16];
		endcase
	end




endmodule