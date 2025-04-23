module matriz_determ5x5(input [199:0] matrix, input clk, input start, output reg done, output [7:0] determinant, output reg overflow);

	reg [199:0] matrix_temp;
	wire [7:0] det_temp;
	reg [7:0] item_temp;
	reg [2:0] count = 0;
	reg start4x4, last_done;
	reg [19:0] det;
	
	matriz_determ4x4(
		matrix_temp,
		clk,
		start4x4,
		done4x4,
		det_temp,
		over4
	);
	
	assign determinant = det[7:0];

	and(done_pulse, !last_done, done4x4); //done_pulse e o resultado do level to pulse
		
	always @(posedge clk) begin;
	
		last_done <= done4x4; //last_done salva o ultimo estado de done4x4, para fazer o level to pulse
		
		//mux matrix
		case (count)
			//Monta matrizes 4x4 dependendo do contador atual, para calcular sua determinante
			0: matrix_temp <= {
			8'b00000000,matrix[160+32 +: 8],matrix[160+24 +: 8],matrix[160+16 +: 8],matrix[160+8 +: 8],
			8'b00000000,matrix[120+32 +: 8],matrix[120+24 +: 8],matrix[120+16 +: 8],matrix[120+8 +: 8],
			8'b00000000,matrix[80+32 +: 8],matrix[80+24 +: 8],matrix[80+16 +: 8],matrix[80+8 +: 8],
			8'b00000000,matrix[40+32 +: 8],matrix[40+24 +: 8],matrix[40+16 +: 8],matrix[40+8 +: 8]};
			
			1: matrix_temp <= {
			8'b00000000,matrix[160+32 +: 8],matrix[160+24 +: 8],matrix[160+16 +: 8],matrix[160 +: 8],
			8'b00000000,matrix[120+32 +: 8],matrix[120+24 +: 8],matrix[120+16 +: 8],matrix[120 +: 8],
			8'b00000000,matrix[80+32 +: 8],matrix[80+24 +: 8],matrix[80+16 +: 8],matrix[80 +: 8],
			8'b00000000,matrix[40+32 +: 8],matrix[40+24 +: 8],matrix[40+16 +: 8],matrix[40 +: 8]};
			
			2: matrix_temp <= {
			8'b00000000,matrix[160+32 +: 8],matrix[160+24 +: 8],matrix[160+8 +: 8],matrix[160 +: 8],
			8'b00000000,matrix[120+32 +: 8],matrix[120+24 +: 8],matrix[120+8 +: 8],matrix[120 +: 8],
			8'b00000000,matrix[80+32 +: 8],matrix[80+24 +: 8],matrix[80+8 +: 8],matrix[80 +: 8],
			8'b00000000,matrix[40+32 +: 8],matrix[40+24 +: 8],matrix[40+8 +: 8],matrix[40 +: 8]};
			
			3: matrix_temp <= {
			8'b00000000,matrix[160+32 +: 8],matrix[160+16 +: 8],matrix[160+8 +: 8],matrix[160 +: 8],
			8'b00000000,matrix[120+32 +: 8],matrix[120+16 +: 8],matrix[120+8 +: 8],matrix[120 +: 8],
			8'b00000000,matrix[80+32 +: 8],matrix[80+16 +: 8],matrix[80+8 +: 8],matrix[80 +: 8],
			8'b00000000,matrix[40+32 +: 8],matrix[40+16 +: 8],matrix[40+8 +: 8],matrix[40 +: 8]};
			
			4: matrix_temp <= {
			8'b00000000,matrix[160+24 +: 8],matrix[160+16 +: 8],matrix[160+8 +: 8],matrix[160 +: 8],
			8'b00000000,matrix[120+24 +: 8],matrix[120+16 +: 8],matrix[120+8 +: 8],matrix[120 +: 8],
			8'b00000000,matrix[80+24 +: 8],matrix[80+16 +: 8],matrix[80+8 +: 8],matrix[80 +: 8],
			8'b00000000,matrix[40+24 +: 8],matrix[40+16 +: 8],matrix[40+8 +: 8],matrix[40 +: 8]};
		endcase
		
		
		//mux p/ o numero que vai multiplicar a 4x4
		case (count) 
			0: item_temp <= matrix[0+:8];
			1: item_temp <= matrix[8+:8];
			2: item_temp <= matrix[16+:8];
			3: item_temp <= matrix[24+:8];
			4: item_temp <= matrix[32+:8];	
		endcase
	
	
	
		//estado de IDLE, aguarda sinal p/ comecar operacao
		if (!start) begin
			done <= 0;
			start4x4 <= 0;
			count <= 0;
			det <= 0;
			overflow <= 0;
		end 
		
		//checa se operacao da 5x5 foi completada, se foi, manda sinal de done
		else begin
		
			overflow <= overflow | over4 | (!(!(|det[19:7]) | (&det[19:7])));
		
			if (count == 5) begin
				done <= 1;
			end
			
			//checa se a operacao da 4x4 (parcial) foi feita realizada, 
			//se nao, manda sinal de start para o modulo, ate ser concluida
			else if (!done_pulse) begin
				start4x4 <= 1;
			end 
			
			//quando a operacao parcial da 4x4 eh realizada
			//o resultado e soma ou subtrai o resultado parcial da det 5x5
			
			else begin
				if(count == 1 | count == 3) begin
					det <= det - (item_temp * det_temp);
				end else begin
					det <= det + (item_temp * det_temp);
				end
				count <= count + 1;
				start4x4 <= 0;		//reinicia sinal de start p/ mod 4x4
			end
		end
		
		
		
		
		
	end
	
	
	
	

endmodule
