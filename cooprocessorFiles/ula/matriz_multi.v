module matriz_multi (
  input signed [199:0] matriz_a, // Matriz A (5x5, 8 bits por elemento)
  input signed [199:0] matriz_b, // Matriz B (5x5, 8 bits por elemento)
  input seletor,
  input clk,
  input wire start,
  output [199:0] result, // Resultado da multiplicação
  output reg done // Sinal de conclusão
);


parameter ZERO = 8'b00000000;

wire [199:0] matriz_c, matriz_d, aux_kernel;
wire [19:0]  r1, r2;
wire [7:0]   absSum;

matriz_transposta(matriz_b,, matriz_c);
assign matriz_d = {matriz_b[8+:8],matriz_b[48+:8],ZERO,ZERO,ZERO,matriz_b[0+:8],matriz_b[40+:8]};

assign aux_kernel = seletor ? matriz_d : matriz_c;

matriz_conv uni_mtr(matriz_a, matriz_b, clk, start, r1, done1);

matriz_conv transp(matriz_a, aux_kernel, clk, start, r2, done2);





assign overflow = |(tempSum[20:8]);

assign absSum = overflow ? 200'hff : tempSum[7:0];


//SELETOR:
//
//0X = 1 matriz
//10 = tipo sobel, 2 kernel transposta
//11 = tipo roberts, 2 kernel 45 graus


reg state = 0;
reg [20:0]tempSum;


always @ (posedge clk) begin

	if (!start) begin
		done <= 0;
		state <= 0;
	end
	else begin
		case (state) 
			0: begin
				if(done1 & done2) begin
					tempSum <= r1+r2;
					state <= 1;
				end
			end
			1: begin
				if(state) begin
					done <= 1;
				end
			end
		endcase
	end
end


assign result = {ZERO,absSum,r2[7:0],r1[7:0]};



endmodule
















