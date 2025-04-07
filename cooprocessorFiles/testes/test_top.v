module test_top(
	input clk,
	input bt1,
	input bt0,
	output [6:0]seg1,
	output [6:0]seg2,
	output [6:0]seg3,
	output [6:0]seg4
);

							// 	N0, 	N1,   ID,LIN,COL, OP
	parameter 	wma0  = 22'b10_00000001_00_000_000_0010,
					wma1  = 22'b00_00000010_00_000_100_0010,
					wma2  = 22'b01_00000000_00_001_001_0010,
					wmb0  = 22'b11_00000100_01_000_000_0010,
					wmb1  = 22'b00_00000010_01_000_100_0010,
					wmb2  = 22'b01_00000000_01_001_001_0010,
					soma  = 22'b0000000000000000000011,
					wmc0  = 22'b11_00000001_00_000_000_0010,
					wmc1	= 22'b01_00000001_00_000_010_0010,
					wmc2 	= 22'b01_00000100_00_000_100_0010,
					wmc3 	= 22'b10_00000001_00_001_001_0010,
					wmc4 	= 22'b01_00000001_00_001_011_0010,
					wmc5 	= 22'b01_00000011_00_010_000_0010,
					wmc6 	= 22'b01_00000001_00_010_010_0010,
					wmc7 	= 22'b11_00000001_00_010_100_0010,
					wmc8 	= 22'b01_00000001_00_011_001_0010,
					wmc9 	= 22'b11_00000001_00_011_011_0010,
					wmc10	= 22'b01_00000001_00_100_000_0010,
					wmc11	= 22'b01_00000001_00_100_010_0010,
					wmc12	= 22'b01_00000000_00_100_100_0010,
					sub	= 22'b0000000000000000000100,
					mult	= 22'b0000000000000000000101,
					trans = 22'b0000000000000000000110,
					opos	= 22'b0000000000000000000111,
					ms5 	= 22'b000000000000000101_1000,
					det2 	= 22'b000000000000000000_1001,
					det3 	= 22'b000000000000000000_1010,
					det4 	= 22'b000000000000000000_1011,
					det5 	= 22'b000000000000000000_1100,
					read0 = 22'b0000000000_10_000_000_0001;



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

		if (i==29) i <= 0;
		else i <= i + 1;

		my_reg <= all[i*22+:22];
	end

	//reg [4000:0] all = {det5,det4,det3, det2,zE,yE,xE,zD, yD, xD,zxC,zzC,zCc,zC,yC,xxC,xC,s,o,t,ms5,m,sum, xA, yA, zA, xB, yB, zB};

	reg [4000:0] all = {read0, det5, det4, det3, det2, wmc12, wmc11, wmc10, wmc9, wmc8, wmc7, wmc6, wmc5, wmc4, wmc3, wmc2, wmc1, wmc0, opos, trans, mult, sub, soma, wmb2, wmb1, wmb0, wma2, wma1, wma0};


endmodule
