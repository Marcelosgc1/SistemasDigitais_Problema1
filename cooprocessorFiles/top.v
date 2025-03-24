module top(
	input [31:0] instruction,
	input activate_instruction,
	input clk,
	output [7:0] leds
);

	parameter 	//STATES
					FETCH = 2'b00,
					DECODE = 2'b01,
					EXECUTE = 2'b10,
					
					//MEM-OPERATIONS
					READ = 4'b0001,
					WRITE = 4'b0010,
					
					//ARI-OPERATIONS
					SUM = 4'b0011,
					SUB = 4'b0100,
					MUL = 4'b0101,
					TRANSP = 4'b0110,
					OPST = 4'b0111,
					MULSCL = 4'b1000,
					DET2 = 4'b1001,
					DET3 = 4'b1010,
					DET4 = 4'b1011,
					DET5 = 4'b1100;
					
	assign leds = matrix_C[7:0];
	reg [2:0] state;
	reg [31:0] fetched_instruction;
	
	reg wr, start, start_memory, start_ALU, start_load, num, flag; 
	wire done, done_alu, done_mem, done_load, rst;
	or op_done(done, done_alu, done_mem, done_load);
	
	reg [215:0] matrix_A; //registradores p/ salvar valores
	reg [215:0] matrix_B;
	wire [199:0] matrix_C;
	wire [15:0] data_out;
	wire [7:0] address, address_load, address_instruc, opcode, opcode_instruc, opcode_load;
	
	decoder(
		fetched_instruction,
		opcode_instruc,
		address_instruc,
		data
	);
	
	//PLACEHOLDER
	
	memory_mod(
		address,
		data,
		start_memory,
		wr,
		clk,
		data_out,
		done_mem
	);
	
	simple_ula(
		clk,
		start_ALU,
		opcode,
		data,
		matrix_A,
		matrix_B,
		matrix_C,
		done_alu
	);
	
	load(
		start_load,
		rst,
		opcode_load,
		load,
		address_load,
		done_load
	);
	assign opcode = load ? opcode_load : opcode_instruc;
	assign address = load ? address_load : address_instruc;
	
	
	always @(posedge clk) begin
		
		//MUX para iniciar operacoes aritimeticas ou de memoria
		if (((opcode == WRITE) | (opcode == READ)) & !flag) begin
			start_memory <= start;
		end else if (!done_load & !start_ALU) begin
			start_load <= start; 
		end else begin
			start_ALU <= start;
		end
	
	
		//MEF
		case (state)
			FETCH: begin
				if (load) begin
					state <= DECODE;
				end else if (activate_instruction) begin	
					fetched_instruction <= instruction;
					state <= DECODE;
				end
			end
			 
			DECODE: begin
				state <= EXECUTE;
			end
			 
			EXECUTE: begin
			
				//done sera enviado da ALU ou Memoria, sinalizando que ja ouve a operacao
				//start sera o sinal para comecar a operacao;
				if (done) begin
					if(READ == opcode) begin
						num = address[3:0];
						case (address[5:4])
							0: matrix_A[num * 16 +:16] = data_out;
							1: matrix_B[num * 16 +:16] = data_out;
							//2: matrix_C[num * 16 +:16] = data_out;
						endcase
						if (load) flag <= 1;
					end else flag <= 0;
					start <= 0;
					state <= FETCH;
				end else begin
					start <= 1;
				end
				
				//certas operacoes precisam que certos sinais sejam enviados p/ os modulos
				if (READ == opcode) begin
					wr <= 0;
				end else if (WRITE == opcode) begin
					wr <= 1;
				end 
				
				
			end
			
			default: state <= FETCH;
			
		endcase
	end

	


endmodule