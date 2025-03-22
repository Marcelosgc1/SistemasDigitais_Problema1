module top(
	input [31:0] instruction,
	input activate_instruction,
	input clk
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
					
	
	reg [2:0] state;
	reg [31:0] fetched_instruction;
	
	reg wr, start, done; 
	
	reg [199:0] matrix_A; //registradores p/ salvar valores
	reg [199:0] matrix_B;
	reg [199:0] matrix_C;
	reg [7:0] data_out;
	
	decoder(
		fetched_instruction,
		opcode,
		address,
		data
	);
	
	//PLACEHOLDER
	/*
	memory_mod(
		adrs,
		data,
		start,
		wr,
		data_out,
		done		
	);
	alu_mod(
		matrix_A,
		matrix_B,
		data,
		start,
		matrix_C,
		data_out,
		done
	);
	*/
	
	always @(posedge clk) begin
		case (state)
			FETCH: begin
				if (activate_instruction) begin	
					fetched_instruction <= instruction;
					state <= DECODE;
				end
			end
			 
			DECODE: begin
				state <= EXECUTE;
			end
			 
			EXECUTE: begin
				case (opcode)
					READ: begin
						wr <= 0;
						start <= 1;
						if (done) begin
							start <= 0;
							state <= FETCH;
						end
					end
					WRITE: begin
						wr <= 1;
						start <= 1;
						if (done) begin
							start <= 0;
							state <= FETCH;
						end
					end
					default: begin
						state <= FETCH;
					end
				endcase
			end
			
			default: state <= FETCH;
			
		endcase
	end

	


endmodule