module matriz_multi (
  input signed [199:0] matriz_a, 
  input signed [199:0] matriz_b, 
  input [1:0]seletor,
  input clk,
  input wire start,
  output [199:0] result, // Resultado da convolucao
  output reg done // Sinal de conclusão
);


parameter ZERO = 8'b00000000;

wire [199:0] matriz_c, matriz_d, aux_kernel;
wire [7:0]   absSum, modulo1, modulo2, result1;


matriz_transposta(matriz_b,, matriz_c);
assign matriz_d = {matriz_b[8+:8],matriz_b[48+:8],ZERO,ZERO,ZERO,matriz_b[0+:8],matriz_b[40+:8]};

assign aux_kernel = seletor[0] ? matriz_d : matriz_c;



matriz_conv uni_mtr(matriz_a, matriz_b, clk, start, modulo1, signal, done1);
matriz_conv transp(matriz_a, aux_kernel, clk, start, modulo2, , done2);


assign result1 = (!seletor[1] & signal) ? 8'h00 : modulo1;


//SELETOR:
//
//0X = 1 matriz (fazer saturaçao dupla)
//10 = tipo sobel, 2 kernel transposta
//11 = tipo roberts, 2 kernel 45 graus




reg state = 0;
reg [8:0]tempSum;

assign absSum = tempSum[8] ? 8'hff : tempSum[7:0];

always @ (posedge clk) begin

	if (!start) begin
		done <= 0;
		state <= 0;
	end
	else begin
		case (state) 
			0: begin
				if(done1 & done2) begin
					tempSum <= modulo1+modulo2;
					state <= 1;
				end
			end
			1: begin
				done <= 1;
			end
		endcase
	end
end


assign result = {ZERO,absSum,modulo2,result1};



endmodule
