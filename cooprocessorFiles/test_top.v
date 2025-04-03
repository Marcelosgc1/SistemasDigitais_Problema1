module test_top(
	input clk,
	input bt1,
	input bt0,
	output [6:0]seg1, 
	output [6:0]seg2, 
	output [6:0]seg3, 
	output [6:0]seg4 
);


	parameter 	xA = 22'b10_00000001_00_000_000_0010,
					yA = 22'b00_00000001_00_000_100_0010,
					zA = 22'b10_00000000_00_001_001_0010,
					xB = 22'b10_00000001_01_000_000_0010,
					yB = 22'b00_00000001_01_000_100_0010,
					zB = 22'b10_00000000_01_001_001_0010,
					sum = 22'b0000000000000000000011,
					xC = 22'b11_01111111_00_000_000_0010,
					yC = 22'b00_11100111_00_000_100_0010,
					zC = 22'b10_00000000_00_001_001_0010,
					xD = 22'b01_11000111_01_000_000_0010,
					yD = 22'b00_11001111_01_000_100_0010,
					zD = 22'b10_00000000_01_001_001_0010,
					s = 22'b0000000000000000000100,
					m = 22'b0000000000000000000101,
					t = 22'b0000000000000000000110,
					o = 22'b0000000000000000000111,
					ms2 = 22'b000000000000000010_1000;


	
	wire [15:0] nums;
	reg [21:0] my_reg;
	reg [4:0] i = 0;

	top(my_reg, db1, clk, nums);

	
	decod7seg(nums[3:0],seg1);
	decod7seg(nums[7:4],seg2);
	decod7seg(nums[11:8],seg3);
	decod7seg(nums[15:12],seg4);
	
	
	debounce(!bt0, clk, db0);
	debounce(!bt1, clk, db1);
	
	always @(posedge db0) begin
		
		if (i==15) i <= 0;
		else i <= i + 1;
	
		my_reg <= all[i*22+:22];
	end
	
	reg [1000:0] all = {s,zD, yD, xD, zC,yC,xC,o,t,m,sum, xA, yA, zA, xB, yB, zB};
	
	
endmodule