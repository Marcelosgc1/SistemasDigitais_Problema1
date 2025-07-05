module top(
	input [31:0] instruction,
	input [1:0] activate_signal,
	input clk,
	input [3:0] key,
	input [9:0] sw,
	//output
	output [31:0] data_read,
	output wait_signal,
	output [6:0] h0,
	output [6:0] h1,
	output [6:0] h2,
	output [6:0] h3,
	output [6:0] h4,
	output [6:0] h5,
	output [9:0] leds,
	inout	[35:0] GPIO_0,
	inout	[35:0] GPIO_1,
	//vga outputs
	output hsync, 
	output vsync,
	output [7:0]red,
	output [7:0]green,
	output [7:0]blue,
	output vga_sync,
	output vga_clk,
	output vga_blank
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
					MUL = 4'b0101, 	//conv. 1 matriz
					TRANSP = 4'b0110,	//conv. 2 matriz transposta
					OPST = 4'b0111,	//conv. 2 matriz 45 graus
					MULSCL = 4'b1000,
					DET2 = 4'b1001,
					DET3 = 4'b1010,
					DET4 = 4'b1011,
					DET5 = 4'b1100,
					PHOTO_CONV = 4'b1110,
					READ_IMAGE = 4'b1111;
					
	assign data_read = hps_read_image ? ram_data_out : data_out;
	
	reg [2:0] state = FETCH;
	reg [31:0] fetched_instruction = 0;
	reg [1:0] count_br;
	
	reg wr, start, start_memory, start_ALU, loaded, implict_memory = 0, write_resul = 0, last_done; 
	wire done, done_alu, done_mem, done_pulse, activate_instruction, activate_ipu;
	
	assign activate_instruction = activate_signal[0];
	assign activate_ipu = activate_signal[0];
	
	reg [7:0] count_mem;
	
	wire [199:0] matrix_A, operandA; //registradores p/ salvar valores
	wire [199:0] matrix_B, operandB;
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
		operandA,
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
	
	assign operandA = ipu_request ? buf_matrix : matrix_A;
	assign wait_signal = state != FETCH;
	assign done_pulse = done & !last_done;
	assign done = (loaded & !write_resul) ? done_alu : done_mem;
	assign data_to_write = write_resul ? result_ula : data;
	assign address = implict_memory ? count_mem : address_instruction;
	
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
			//Estado de busca
			FETCH: begin
				//quando recebe activate_instruction, muda de estado
				if (activate_instruction | ipu_request) begin	
					fetched_instruction = ipu_request ? ipu_inst : instruction;
					state = DECODE;
				end else begin
					state = FETCH;
				end
			end
			
			//redireciona estado para de memoria ou operacao de matriz
			DECODE: begin
				if ((opcode == WRITE) | (opcode == READ)) begin
					state = MEMORY;
				end else begin
					state = EXECUTE;
				end
			end
			
			//Estado para operacoes de memoria
			MEMORY: begin
				//operacao explicita de memoria
				if ((opcode == WRITE) | (opcode == READ)) begin
					implict_memory = 0;
					if (done_pulse) begin
						start = 0;
						state = FETCH;
						wr = 0;
					end else begin
						wr = (opcode == WRITE);
						start = 1;
					end
					
				//operacao implicita de memoria
				//salva/carrega valores da memoria em registradores para operar matrizes
				end else begin
					implict_memory = 1;
					//aguarda modulo de memoria completar leitura
					if (done_pulse) begin
						start = 0;
						//aguarda banco de registrador ser escrito
						if (count_br < 2) begin
							count_br = count_br + 1;
						//comeca a contar cada endereco de memoria
						end else if (count_mem[3:0] < 12) begin
							count_mem[3:0] = count_mem[3:0] + 1;
							loaded = 0;
							count_br = 0;
							state = MEMORY;
						end else if (!(count_mem[4] | count_mem[5])) begin
							count_mem[3:0] = 0;
							count_mem[4] = 1;
							loaded = 0;
							count_br = 0;
							state = MEMORY;
						end else if (count_mem[5]) begin
							wr = 0;
							count_mem = 0;
							write_resul = 0;
							count_br = 0;
							state = FETCH;
						end else if (write_resul) begin
							count_mem[4] = 0;
							count_mem[5] = 1;
							count_mem[3:0] = 0;
							wr = 1;
							count_br = 0;
							state = MEMORY;
						//matrizes carregadas
						end else begin
							loaded = 1;
							implict_memory = 0;
							count_br = 0;
							state = EXECUTE;
						end
					end else begin
						loaded = 0;
						start = 1;
					end
				
				
				end
			end
			
			//realiza operacoes de matriz
			EXECUTE: begin
				//manda carregar matrizes
				if (!loaded) state = MEMORY;
				else begin
					//manda escrever na memoria
					if (done_pulse) begin
						start = 0;
						loaded = 0;
						write_resul = 1;
						state = MEMORY;
						
					//aguarda alu terminar operacao
					end else begin
						start = 1;
					end
				end
			end
			
			default: state = FETCH;
			
		endcase
	end

	

	assign convolution_opcode = (opcode==MUL || opcode==TRANSP || opcode==OPST);
	reg write_vga, select_cam, curr_result, start_process, ipu_request, start_buf;
	reg [1:0]size;
	reg [2:0]ipu_state, loader;
	reg [7:0]pixel_color;
	reg [8:0]h_count_conv, v_count_conv, h_count_buf, v_count_buf;
	reg [31:0] ipu_inst;
	wire [199:0] buf_matrix;
	wire [31:0] cam_data, conv_data, ram_data_out, data_in;						
	wire [15:0] cam_address, conv_address, addr, hps_image_address, address_buf;
	wire [8:0]h_count, v_count;
	wire cam_valid_pixel, cam_clock, cam_we, conv_we, memory_clk;
	
	assign address_buf = {v_count_buf, h_count_buf[8:2]};
	assign WRITE_ENABLE = cam_we | conv_we;
	assign addr = start_buf ? address_buf : hps_read_image ? hps_image_address : cam_we | cam_valid_pixel ? cam_address : conv_address;
	assign memory_clk = cam_we | cam_valid_pixel ? cam_clock : clk;
	assign data_in = cam_we | cam_valid_pixel ? cam_data : conv_data;
	//assign ipu_request = instruction[3:0]==RENDERIZAR & activate_ipu;
	assign h_count = ipu_state==1 ? h_count_buf : h_count_conv;
	assign v_count = ipu_state==1 ? v_count_buf : v_count_conv;
	
	assign hps_read_image = instruction[3:0]==READ_IMAGE;
	assign hps_image_address = instruction[19:4];
	
	always @ (posedge clk) begin
		
		case (ipu_state)
			0: begin
				if(instruction[3:0]==PHOTO_CONV & !start_process) begin
					ipu_state <= 1;
					size <= instruction[5:4];
					start_process <= 1;
				end else if (instruction[3:0]!=PHOTO_CONV) begin
					start_process <= 0;
				end
				start_buf <= 0;
				loader <= 0;
				h_count_buf <= 0;
				v_count_buf <= 0;
				h_count_conv <= 0;
				v_count_conv <= 0;
				ipu_state <= 0;
				ipu_request <= 0;
				curr_result <= 0;
			end
			
			1: begin
				if (!start_buf) begin
					start_buf <= 1;
					loader <= size + 1;
				end else begin
					loader <= loader - (h_count_buf == 9'd508);
					h_count_buf <= (h_count_buf == 9'd508) ? 0 : h_count_buf + 4;
					v_count_buf <= v_count_buf + (h_count_buf == 9'd508);
					ipu_state <= (h_count_buf == 9'd508) & loader == 0 ? 2 : 1 ;
					start_buf <= (h_count_buf != 9'd508) | loader != 0;
				end
			end
			
			2: begin
				if (!wait_signal) begin
					ipu_request <= 1;
					ipu_inst <= {h_count_conv,v_count_conv,4'b0111};
					curr_result <= 0;
				end else if (ipu_request) begin
					if (done_alu & !curr_result) begin
						curr_result <= 1;
						ipu_request <= 0;
						if(h_count_conv==9'h1ff)begin
							if (v_count_conv==9'h1df) begin
								ipu_state <= 0;
							end else begin
								h_count_conv <= 0;
								v_count_conv <= v_count_conv + 1;
								loader <= 0;
								ipu_state <= 1;
								start_buf <= 1;
							end
						end
						else begin
							h_count_conv <= h_count_conv + 1;
						end
					end
				
				end
			
			end
		
		endcase
	
	
		
		
		if (convolution_opcode & done_alu & !write_vga) begin
			pixel_color <= (opcode==MUL) ? (matrix_C[7:0]) : (matrix_C[23:16]);
			write_vga <= 1;
		end
		else if (write_vga & vga_ram_done) begin
			write_vga <= 0;
		end
	end
	
	DE2_D5M(
		clk,
		key,
		sw,
		h0,h1,h2,h3,h4,h5,
		leds,
		GPIO_0,
		GPIO_1,
		cam_data,
		cam_address,
		cam_valid_pixel,
		cam_clock,
		cam_we
	);
	

	
	vga_control(
		sw[3:2],
		fetched_instruction[21:4], 
		clk,
		write_vga,
		pixel_color,
		ram_data_out,
		vga_ram_done,
		conv_address,
		conv_data,
		conv_we,
		hsync, 
		vsync,
		red,
		green,
		blue,			
		vga_sync,
		vga_clk,
		vga_blank
);


	vgaMemory (  
		addr,
		memory_clk,
		data_in,
		WRITE_ENABLE, 
		ram_data_out
	);
	
	
	line_buffers(
		ram_data_out, 
		h_count, 
		v_count,
		start_buf,
		size,
		clk,
		buf_matrix
	);
	

endmodule