module top(
	input [31:0] instruction,
	input activate_instruction,
	input clk,
	output [15:0] data_read
);
	

	parameter 	//STATES
					FETCH = 3'b000,
					DECODE = 3'b001,
					EXECUTE = 3'b010,
					MEMORY = 3'b100,
					
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
					
	/*
	assign leds[5:0] = adrs[5:0];
	assign leds[6] = done_pulse;
	assign leds[7] = done;
	*/
	assign data_read = data_out;
	reg [2:0] state = FETCH;
	reg [31:0] fetched_instruction = 0;
	reg [1:0] count_br;
	
	reg wr, start, start_memory, start_ALU, loaded, seletor = 0, write_resul = 0, last_done; 
	wire done, done_alu, done_mem, done_pulse;
	
	reg [7:0] adrs;
	
	wire [199:0] matrix_A; //registradores p/ salvar valores
	wire [199:0] matrix_B;
	wire [199:0] matrix_C;
	wire [7:0]address_instruction, address;
	wire [3:0] opcode;
	wire [15:0] data, data_out, result_ula, data_to_write;
	
	decoder(
		fetched_instruction,
		opcode,
		address_instruction,
		data
	);
	
	//PLACEHOLDER
	
	memory_mod(
		address,
		data_to_write,
		start_memory,
		wr,
		clk,
		data_out,
		done_mem
	);
	
	alu(
		clk,
		opcode,
		data,
		matrix_A,
		matrix_B,
		start_ALU,
		matrix_C,
		done_alu
	);
	
	br(
		done,
		data_out,
		address,
		matrix_C,
		matrix_A,
		matrix_B,
		result_ula
	);
	assign done_pulse = done & !last_done;
	assign done = (loaded & !write_resul) ? done_alu : done_mem;
	assign data_to_write = write_resul ? result_ula : data;
	assign address = seletor ? adrs : address_instruction;
	
	always @(posedge clk) begin
		
		//level to pulse do sinal de 'done' concluido 
		last_done <= done;
		
		
		//MUX para iniciar operacoes aritimeticas ou de memoria
		if ((opcode == WRITE) | (opcode == READ) | !loaded | write_resul) begin
			start_memory <= start;
		end else begin
			start_ALU <= start;
		end
	
	
		//MEF
		case (state)
			FETCH: begin
				if (activate_instruction) begin	
					fetched_instruction = instruction;
					state = DECODE;
				end else begin
					state = FETCH;
				end
			end
			
			DECODE: begin
				if ((opcode == WRITE) | (opcode == READ)) begin
					state = MEMORY;
				end else begin
					state = EXECUTE;
				end
			end
			
			MEMORY: begin
				if ((opcode == WRITE) | (opcode == READ)) begin
					seletor = 0;
					if (done_pulse) begin
						start = 0;
						state = FETCH;
						wr = 0;
					end else begin
						wr = (opcode == WRITE);
						start = 1;
					end
				end else begin
					seletor = 1;
					if (done_pulse) begin
						start = 0;
						if (count_br < 2) begin
							count_br = count_br + 1;
						end else if (adrs[3:0] < 12) begin
							adrs[3:0] = adrs[3:0] + 1;
							loaded = 0;
							count_br = 0;
							state = MEMORY;
						end else if (!(adrs[4] + adrs[5])) begin
							adrs[3:0] = 0;
							adrs[4] = 1;
							loaded = 0;
							count_br = 0;
							state = MEMORY;
						end else if (adrs[5]) begin
							wr = 0;
							adrs = 0;
							write_resul = 0;
							count_br = 0;
							state = FETCH;
						end else if (write_resul) begin
							adrs[4] = 0;
							adrs[5] = 1;
							adrs[3:0] = 0;
							wr = 1;
							count_br = 0;
							state = MEMORY;
						end else begin
							loaded = 1;
							seletor = 0;
							count_br = 0;
							state = EXECUTE;
						end
					end else begin
						loaded = 0;
						start = 1;
					end
				
				
				end
			end
			
			EXECUTE: begin
				if (!loaded) state = MEMORY;
				else begin
					if (done_pulse) begin
						start = 0;
						loaded = 0;
						write_resul = 1;
						state = MEMORY;
					end else begin
						start = 1;
					end
				end
			end
			default: state = FETCH;
			
		endcase
	end

	


endmodule