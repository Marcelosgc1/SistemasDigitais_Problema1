module decoder(input [31:0]instruction, output [3:0]opcode, output [7:0]adrs, output [15:0]data);

	assign opcode = instruction[3:0];
	wire [5:0]location;
	wire [1:0]id;
	
	assign location = instruction[4+:6];
	assign id = instruction[10+:2];
	
	assign adrs[0] = (!location[4] & !location[1] & location[0]) | 
					(!location[4] & !location[3] & location[1]) | 
					(location[4] & !location[3] & !location[1]) | 
					(location[4] & location[1] & location[0]);
	assign adrs[1] = (location[5] ^ location[2]) | 
				  (!location[4] & !location[1] & location[0]) | 
				  (location[4] & !location[3] & location[1]);
	assign adrs[2] = (location[4] & !location[3]) | 
				  (location[5] & location[2]) | 
				  (!location[4] & location[1] & location[0]);
	assign adrs[3] = location[5] | 
				  (location[4] & location[0]);
	assign adrs[4] = id[0];
	assign adrs[5] = id[1];
	assign adrs[6] = 0;
	assign adrs[7] = 0;
	
	assign data = 	opcode[3] ? 
						instruction[4+:16] :
						instruction[12+:16];

endmodule