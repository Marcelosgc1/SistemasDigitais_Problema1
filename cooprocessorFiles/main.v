module main(
	input wire clk,
	output [7:0] data_c
);


	reg[7:0] size;
	reg[7:0] address;
	reg clk2;
	reg[4:0] index_A = 0;
	reg[4:0] index_B = 0;
	reg[4:0] i = 0;
	reg[4:0] i_A = 0;
	reg[4:0] i_B = 0;
	reg[7:0] matriz_A [0:24];
	reg[7:0] matriz_B [0:24];
	reg activate;
	reg[24:0] counter;
	wire [7:0] data;
	
	
	
	ram1port(
		address,
		clk,
		8'b0,
		0,
		data
	);
	
	
	matriz_soma(
		clk2,
		matriz_A[i],
		matriz_B[i],
		data_c
	);
	
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
	
	
	//iteracao das matrizes na memoria
	always @(posedge clk)begin
		if(address == 0) begin
			size <= data;
			address <= address + 1;
		end else if (address <= size*size) begin
			matriz_A[index_A] <= data;
			index_A <= index_A + 1;
			address <= address + 1;
		end else if (address <= (size*size)*2)begin
			matriz_B[index_B] <= data;
			index_B <= index_B + 1;
			address <= address + 1;
		end 
	end
	
	always @(posedge clk2)begin
		i_A <= i;
		i_B <= i;
		i <= i + 1;
	end
endmodule