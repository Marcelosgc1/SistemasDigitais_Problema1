//MULTIPLICAÇAO 20 ADP BLOCK

module matriz_multi (
  input signed [199:0] matriz_a,
  input signed [199:0] matriz_b, 
  input clock,
  input wire start,
  output reg signed [199:0] matriz_c = 0,
  output reg done
);

	reg [2:0] linha = 0; 
	reg signed [15:0] temp [0:4];     

	always @(posedge clock) begin
		 if(start) begin
		         integer i;
			 for (i = 0; i < 5; i = i + 1) begin
				  temp[i] = (matriz_a[(linha * 40) + 7 -: 8]   * matriz_b[(i * 8) +: 8]) +
								(matriz_a[(linha * 40) + 15 -: 8]  * matriz_b[(i * 8) + 40 +: 8]) +
								(matriz_a[(linha * 40) + 23 -: 8]  * matriz_b[(i * 8) + 80 +: 8]) +
								(matriz_a[(linha * 40) + 31 -: 8]  * matriz_b[(i * 8) + 120 +: 8]) +
								(matriz_a[(linha * 40) + 39 -: 8]  * matriz_b[(i * 8) + 160 +: 8]);
			 end
			 
			 for (i = 0; i < 5; i = i + 1) begin
				  matriz_c[(linha * 40) + (i * 8) + 7 -: 8] <= temp[i][7:0];
			 end

			 if (linha == 4) begin
				  linha <= 0;
				  done <= 1;
			 end else begin
				  linha <= linha + 1;
				  done <= 0;
			 end
		end
	end

endmodule
