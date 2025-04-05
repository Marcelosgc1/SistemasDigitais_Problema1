module matriz_determ5x5(input [199:0] matrix, input clk, input start, output reg done, output reg [7:0] det);

	reg [199:0] matrix_temp;
	wire [7:0] det_temp;
	reg [7:0] item_temp;
	reg [2:0] count = 0;
	reg start2, last_done;
	
	matriz_determ4x4(
		matrix_temp,
		clk,
		start2,
		done2,
		det_temp
	);


	and(done_pulse, !last_done, done2);
		
	always @(posedge clk) begin;
	
		last_done <= done2;
		
		//mux matrix
		case (count)
			//Monta matrizes 4x4 dependendo do contador
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
		
		
		//mux num
		case (count) 
			0: item_temp <= matrix[0+:8];
			1: item_temp <= matrix[8+:8];
			2: item_temp <= matrix[16+:8];
			3: item_temp <= matrix[24+:8];
			4: item_temp <= matrix[36+:8];	
		endcase
	
	
	
		
		if (!start) begin
			done <= 0;
			start2 <= 0;
			count <= 0;
			det <= 0;
		end else

		
		if (!done_pulse) begin
			start2 <= 1;
		end else
		
		
		if (count != 5) begin
			if(count == 1 | count == 3) begin
				det <= det - (item_temp * det_temp);
			end else begin
				det <= det + (item_temp * det_temp);
			end
		
			count <= count + 1;
			start2 <= 0;
		end
		
		
		else begin
			done <= 1;
		end
		
		
		
		
	end
	
	
	
	

endmodule
