module main(
	input wire clk,
	input [1:0]operation, //mudar p/ 32 bits no futuro, aq eh so opcode
	output reg [7:0] leds,
	output reg wren,
	input start_operation,
	output reg [7:0] address
);



	reg [7:0]matrix_address = 1;
	reg clk2,clk3;
	reg [7:0] i = 0;
	reg [255:0] matriz_A;
	reg [255:0] matriz_B;
	reg finished, read_finished, flag_Z = 0, flag_A = 0, flag_B = 0, flag_C = 0, flag_D = 0;
	reg [24:0] counter;
	reg [1:0] counter2;
	wire[255:0] data, data_c, data_c_sum, data_c_sub;

	//reg wren;

	assign data_c = operation[0] ? data_c_sub : data_c_sum;
	and(mclk,clk,start_operation);

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


	//iteracao das matrizes na memoria
	always @(posedge mclk)begin
		if (flag_Z == 0) begin
			flag_Z = 1;
		end else if(flag_A == 0) begin
			matriz_A = data;
			flag_A = 1;
			matrix_address = 2;
			/*end else if (flag_B == 0) begin
			matrix_address = 2;
			flag_B = 1;*/
		end else if (flag_C == 0) begin
			matriz_B = data;
			flag_C = 1;
		end else begin
			read_finished <= 1;
		
	end


		leds <= data[7:0];
		if (operation[1]) begin
			read_finished <= 0;
			wren <= 0;
			finished <= 0;
			matrix_address = 1;
			flag_Z = 0;
			flag_A = 0;
			flag_B = 0;
			flag_C = 0;
			flag_D = 0;
		end else if (finished) begin
			wren <= 0;
		end else if (flag_D == 1) begin
			wren <= 1;
			finished <= 1;
		end else if (read_finished) begin
			address = 3;
			flag_D = 1;
		end else begin
			address = matrix_address;
			wren <= 0;
		end
	end






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
	
	always @(posedge clk) begin
		if(counter2 == 25'b11)
			counter2 <= 0;
		else
			counter2 <= counter + 1;
		if (counter2 == 0)
			clk3 <= 1;
		else
			clk3 <= 0;
	end

	and(clk_op, clk2, read_finished); //versao final mudar clk2 p/ clk
	//demonstraçao nos leds do DE1-SoC
	/*always @(posedge clk_op) begin
		if (i >= 3'd192) begin
			i <= 0;
		end else begin
			i <= i + 8;
		end
	end*/
	
	
endmodule