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
wire [20:0]  r1, r2, r10, newR1, aux1, aux2, aux3;
wire [7:0]   absSum;


matriz_transposta(matriz_b,, matriz_c);
assign matriz_d = {matriz_b[8+:8],matriz_b[48+:8],ZERO,ZERO,ZERO,matriz_b[0+:8],matriz_b[40+:8]};



assign aux_kernel = seletor[0] ? matriz_d : matriz_c;



matriz_conv uni_mtr(matriz_a, matriz_b, clk, start, r1, r10, done1);
matriz_conv transp(matriz_a, aux_kernel, clk, start, r2, , done2);




assign overflowPOS = |(r10[20:8]);
assign overflowNEG = !(&(r10[20:8]));

assign aux1 = overflowPOS ? 8'hff : r10[7:0];
assign aux2 = overflowNEG ? 8'h00 : r10[7:0];
assign aux3 = r10[20] ? aux2 : aux1;

assign newR1 = seletor[1] ? r1 : aux3;



//assign overflowPOSR1 = |(unsat1[20:8]);
//assign overflowNEGR1 = !(&(unsat1[20:8]));
//
//
//assign r1 = seletor[1] ? (overflowPOSR1 ? 200'hff : unsat1[7:0]) : (unsat1[20] ? (overflowNEGR1 ? 200'h0 : unsat1[7:0]) : (overflowPOSR1 ? 200'hff : unsat1[7:0]));
//




//SELETOR:
//
//0X = 1 matriz (fazer saturaçao dupla)
//10 = tipo sobel, 2 kernel transposta
//11 = tipo roberts, 2 kernel 45 graus




reg state = 0;
reg [20:0]tempSum;

assign overflow = |(tempSum[20:8]);
assign absSum = overflow ? 200'hff : tempSum[7:0];

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


assign result = {ZERO,absSum,r2[7:0],newR1[7:0]};



endmodule
















