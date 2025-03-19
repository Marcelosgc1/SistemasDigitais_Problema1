module main(
	input wire clk,
	input [1:0]operation, //mudar p/ 32 bits no futuro, aq eh so opcode
	output reg [7:0] leds,
	output reg wren,
	input rst,
	input start_operation
);



	reg [7:0]matrix_address = 1;
	reg clk2;
	reg [7:0] i = 0;
	reg [255:0] matriz_A;
	reg [255:0] matriz_B;
	reg finished, read_finished, flag_Z = 0, flag_A = 0, flag_D = 0;
	reg [1:0] counter;
	wire[255:0] data, data_c, data_c_sum, data_c_sub, data_c_transpose;
	reg [7:0] address;

	//reg wren;

	assign data_c = operation[0] ? operation[1] ? data_c_transpose : data_c_sub : data_c_sum;
	and(mclk,clk2,start_operation);

	ram1port256bits(
		address,
		clk,
		data_c,
		wren,
		data
	);


	matriz_soma(
		matriz_A,
		matriz_B,
		data_c_sum
	);

	matrix_subtraction(
		matriz_A,
		matriz_B,
		data_c_sub
	);
	
	matrix_transposition(
		matriz_A,
		data_c_transpose
	);

	//iteracao das matrizes na memoria
	always @(posedge mclk)begin
		if (flag_Z == 0) begin
			flag_Z = 1;
		end else if(flag_A == 0) begin
			matriz_A = data;
			matrix_address = 2;
			flag_A = 1;
			matriz_B = data;
		end else begin
			read_finished <= 1;
		
	end


		leds <= data[7:0];
		if (!rst) begin
			read_finished <= 0;
			wren = 0;
			finished <= 0;
			matrix_address = 1;
			flag_Z = 0;
			flag_A = 0;
			flag_D = 0;
		end else if (finished) begin
			wren = 0;	
		end else if (read_finished) begin
			address = 3;
			flag_D = 1;
			wren = 1;
			finished = 1;
		end else begin
			address = matrix_address;
			wren = 0;
		end
	end


	//clock das operaçoes
	always @(posedge clk) begin
		if(counter == 2'b11)
			counter <= 0;
		else
			counter <= counter + 1;
		if (counter == 0)
			clk2 <= 1;
		else
			clk2 <= 0;
	end

	
	
endmodule