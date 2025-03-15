module main2(
	input wire clk,
	output reg [7:0] leds
);

	

	reg [7:0]matrix_address;
	reg clk2;
	reg [7:0] i = 0;
	reg [255:0] matriz_A;
	reg [255:0] matriz_B;
	reg finished, read_finished;
	reg [24:0] counter;
	wire[255:0] data;
	reg [7:0] address;
	reg wren;
	
	
	
	ram1port256bits(
		address,
		clk,
		data_c,
		read_finished,
		data
	);
	
	
	matriz_soma(
		matriz_A,
		matriz_B,
		data_c
	);
	
	
	//iteracao das matrizes na memoria
	always @(posedge clk)begin
		if (read_finished) begin
			address <= 2;
			wren <= 1;
		end else begin
			address <= matrix_address;
			wren <= 0;
		end
	
		if(matrix_address == 0) begin
			matriz_A <= data;
			matrix_address <= matrix_address + 1;	
		end else if (matrix_address == 1) begin
			matriz_B <= data;
			read_finished <= 1;
		end
	end
	
	and(clk_sum, clk2, read_finished); //versao final mudar clk2 p/ clk
	
	
	
	
	//Contador p/ visualizaçao via leds
	always @(posedge clk) begin
		if(counter == 25'b1111111111111111111111111)
			counter <= 0;
		else
			counter <= counter + 1;
		if (counter == 0)
			clk2 <= 1;
		else
			clk2 <= 0;	
	end
	//demonstraçao nos leds do DE1-SoC
	always @(posedge clk_sum) begin
		leds <= data[i+:8];
		if (i >= 3'd192) begin
			i <= 0;
		end else begin
			i <= i + 8;
		end
		finished <= 1;
	end
endmodule