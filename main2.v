module main2(
   input clk,
	output [7:0] data_c
);

	reg[3:0] index, clk2;
	reg [7:0] regis [1:0];
	reg[24:0] counter;
	reg activate;

	wire wren_c;
	wire [7:0] q_a;

	ram1port(
		index,
		clk,
		8'b0,
		0,
		q_a
	);

	matriz_soma(
		activate,
		regis[0],
		regis[1],
		data_c,
	);

	always @(posedge clk) begin
		counter <= (counter == 25'b1111111111111111111111111) ? 0 : counter + 1;
		if (counter == 0) begin clk2 <= 1; end else begin clk2 <= 0; end
	end

	always @(posedge clk2) begin
		index <= (index == 31) ? 0 : index + 1;
		if (index == 0) begin
			regis[0] <= q_a;
			activate = 0;
		end else if (index == 1) begin
			regis[1] <= q_a;
			activate = 1;
		end
	end

	//testando 
	/*
	integer i;
	generate
		for(i=0; i<=8; i=i+1) begin

		end
	endgenerate 
	*/

endmodule