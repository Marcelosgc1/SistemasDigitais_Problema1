module top(
	input [31:0] instruction,
	input activate_instruction,
	input clk
);


	parameter 	FETCH = 2'b00,
					DECODE = 2'b01,
					EXECUTE = 2'b10,
					READ = 4'b0001,
					WRITE = 4'b0010,
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
	
	decoder(
		fetched_instruction,
		opcode,
		address,
		data
	);
	
	always @(posedge clk) begin
            case (state)
                FETCH: begin
						if (activate_instruction) begin
							fetched_instruction = instruction;
							state = DECODE;
						end else state = FETCH;
                end
                
                DECODE: begin    
                    state = EXECUTE;
                end
                
                EXECUTE: begin
                    case (opcode)
                        READ: begin
                            wr <= 0;
                            start = 1;
                            if (done) begin
                                start = 0;
                                state = FETCH;
                            end else state = EXECUTE;
                        end
                        default: begin
                            state = FETCH;
                        end
                    endcase
                end 
                default: state = FETCH;
            endcase
        end

	


endmodule