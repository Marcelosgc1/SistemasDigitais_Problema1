module simple_ula(
	input clk,
	input start,
	input wire [3:0] opcode,
	input wire [7:0] data_escalar,
	input wire [199:0] matrizA,
	input wire [199:0] matrizB,
	output reg [199:0] matriz_resultante,
	output reg done
);
	
	wire [199:0] matriz_soma;
	//SOMA
	genvar i;
	generate
		for (i = 0; i<200; i = i + 8) begin : soma_matrizes
			assign matriz_soma[i +: 8] = matrizA[i +: 8] + matrizB[i +: 8];
		end
	endgenerate


	always @(posedge clk) begin
		if (!start) begin
			done = 0;
		end else

		if (start & !done) begin
			case (opcode)
				3: begin
					matriz_resultante = matriz_soma;
					done = 1;
				end
				//subtracacao
				//mult
				//...
				default: begin
					done = 1;
				end
			endcase
		end
	end

endmodule
