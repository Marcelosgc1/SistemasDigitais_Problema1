`timescale 1ns/1ps 

module main_tb;
	reg clk, [7:0] andressA, [7:0] andressB, [2:0] opcode;
	wire [7:0] andressC;

	main uut (
	  .clk(clk),
	  .andressA(andressA),
	  .andressB(andressB),
	  .andressC(andressC)
	);

	always #5 clk = ~clk;

	initial begin
	  clk = 0;
	  andressA = 8'b00000001;
	  andressB = 8'b00000002;
     andressC = 8'b00000003;
	  
	  // Primeiro teste com soma
	  opcode = 3'b000;
	  
	  #300
	  // Segundo teste com subtração
	  opcode = 3'b001;
	  
	  #300
	  // Terceiro teste com multiplicação
	  opcode = 3'b010;
	  
	   
	  #300
	  // Quarto teste com multiplicação escalar
	  opcode = 3'b011;
	  
	   
	  #300
	  // Quinto teste com determinante
	  opcode = 3'b100;
	  
	   
	  #300
	  // Sexto teste com transposição
	  opcode = 3'b101;
	  
	  #300
	  // Sétimo teste com matriz oposta
	  opcode = 3'b110;
	 
	  
	  #2000;
	  $finish;
	end

  
endmodule
