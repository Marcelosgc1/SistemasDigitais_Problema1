module main2(
	input wire clk,
	output [7:0] data_c
);

	

	reg [7:0]matrix_adress;
	reg clk2;
	reg [4:0] i = 0;
	reg [255:0] matriz_A;
	reg [255:0] matriz_B;
	reg finished, read_finished;
	reg [24:0] counter;
	wire[255:0] data;
	wire [7:0] address;
	wire wren;
	
	
	
	ram1port(
		address,
		clk,
		data_c,
		wren,
		data
	);
	
	
	matriz_soma(
		matriz_A,
		matriz_B,
		data_c
	);
	
	assign address = read_finished ? 2 : matrix_adress;
	assign wren = read_finished ? 1 : 0; // eu sei q isso parece idiota ok
	
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
		if(matrix_adress == 0) begin
			matriz_A <= data;
			matrix_adress <= matrix_adress + 1;	
		end else if (matrix_adress == 1) begin
			matriz_B <= data;
			read_finished <= 1;
		end
	end
	
	and(clk_sum, clk2, read_finished); //versao final mudar clk2 p/ clk
	
	always @(posedge clk_sum) begin
		i <= i + 1;
		finished <= 1;
	end
endmodule