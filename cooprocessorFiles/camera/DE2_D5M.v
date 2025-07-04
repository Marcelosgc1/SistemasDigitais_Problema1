// --------------------------------------------------------------------
// Copyright (c) 2007 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	DE2 D5M VGA
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny FAN        :| 07/07/09  :| Initial Revision
// --------------------------------------------------------------------

module DE2_D5M
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_50,						//	50 MHz
		////////////////////	Push Button		////////////////////
		KEY,							//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		SW,								//	Toggle Switch[17:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0,							//	Seven Segment Digit 0
		HEX1,							//	Seven Segment Digit 1
		HEX2,							//	Seven Segment Digit 2
		HEX3,							//	Seven Segment Digit 3
		HEX4,							//	Seven Segment Digit 4
		HEX5,							//	Seven Segment Digit 5
		////////////////////////	LED		////////////////////////
		LEDR,							//	LED Red[17:0]
		
		////////////////////	GPIO	////////////////////////////
		GPIO_0,							//	GPIO Connection 0
		GPIO_1,							//	GPIO Connection 1
		memoryDataO,
		muxAddress,
		validPixelO,
		newClock,
		writeEnableO
	);

////////////////////////	Clock Input	 	////////////////////////
input			CLOCK_50;				//	50 MHz
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[9:0]	SW;						//	Toggle Switch[17:0]

////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0;					//	Seven Segment Digit 0
output	[6:0]	HEX1;					//	Seven Segment Digit 1
output	[6:0]	HEX2;					//	Seven Segment Digit 2
output	[6:0]	HEX3;					//	Seven Segment Digit 3
output	[6:0]	HEX4;					//	Seven Segment Digit 4
output	[6:0]	HEX5;					//	Seven Segment Digit 5
////////////////////////////	LED		////////////////////////////
output	[9:0]	LEDR;					//	LED Red[17:0]
////////////////////////////	UART	////////////////////////////
////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO_0;					//	GPIO Connection 0
inout	[35:0]	GPIO_1;					//	GPIO Connection 1
////////////////////////	MEMORY	////////////////////////////////
output [15:0] muxAddress;
output newClock;
output [31:0] memoryDataO;
output writeEnableO;
output validPixelO;
///////////////////////////////////////////////////////////////////
//=============================================================================
// REG/WIRE declarations
//=============================================================================

//	CCD
wire	[11:0]	CCD_DATA;
wire			CCD_SDAT;
wire			CCD_SCLK;
wire			CCD_FLASH;
wire			CCD_FVAL;
wire			CCD_LVAL;
wire			CCD_PIXCLK;
wire			CCD_MCLK;				//	CCD Master Clock

wire	[15:0]	Read_DATA1;
wire	[15:0]	Read_DATA2;
wire			VGA_CTRL_CLK;
wire	[11:0]	mCCD_DATA;
wire			mCCD_DVAL;
wire			mCCD_DVAL_d;
wire	[15:0]	X_Cont;
wire	[15:0]	Y_Cont;
wire	[9:0]	X_ADDR;
wire	[31:0]	Frame_Cont;
wire			DLY_RST_0;
wire			DLY_RST_1;
wire			DLY_RST_2;
wire			Read;
reg		[11:0]	rCCD_DATA;
reg				rCCD_LVAL;
reg				rCCD_FVAL;
wire	[11:0]	sCCD_R;
wire	[11:0]	sCCD_G;
wire	[11:0]	sCCD_B;
wire			sCCD_DVAL;
wire	[9:0]	VGA_R;   				//	VGA Red[9:0]
wire	[9:0]	VGA_G;	 				//	VGA Green[9:0]
wire	[9:0]	VGA_B;   				//	VGA Blue[9:0]
reg		[1:0]	rClk;
wire			sdram_ctrl_clk;

//=============================================================================
// Structural coding
//=============================================================================
assign	CCD_DATA[0]	=	GPIO_1[13];
assign	CCD_DATA[1]	=	GPIO_1[12];
assign	CCD_DATA[2]	=	GPIO_1[11];
assign	CCD_DATA[3]	=	GPIO_1[10];
assign	CCD_DATA[4]	=	GPIO_1[9];
assign	CCD_DATA[5]	=	GPIO_1[8];
assign	CCD_DATA[6]	=	GPIO_1[7];
assign	CCD_DATA[7]	=	GPIO_1[6];
assign	CCD_DATA[8]	=	GPIO_1[5];
assign	CCD_DATA[9]	=	GPIO_1[4];
assign	CCD_DATA[10]=	GPIO_1[3];
assign	CCD_DATA[11]=	GPIO_1[1];
assign	GPIO_1[16]	=	CCD_MCLK;
assign	CCD_FVAL	=	GPIO_1[22];
assign	CCD_LVAL	=	GPIO_1[21];
assign	CCD_PIXCLK	=	GPIO_1[0];
assign	GPIO_1[19]	=	1'b1;  // tRIGGER
assign	GPIO_1[17]	=	DLY_RST_1;
assign	newClock = CCD_PIXCLK;
assign	memoryDataO = memoryData;
assign	writeEnableO = writeEnable;
assign validPixelO = mCCD_DVAL;


assign	LEDR		=	Y_Cont;

assign	VGA_CTRL_CLK=	rClk[0];
assign	VGA_CLK		=	~rClk[0];

always@(posedge CLOCK_50)	rClk	<=	rClk+1;


always@(posedge CCD_PIXCLK)
begin
	rCCD_DATA	<=	CCD_DATA;
	rCCD_LVAL	<=	CCD_LVAL;
	rCCD_FVAL	<=	CCD_FVAL;
end

Reset_Delay			u2	(	.iCLK(CLOCK_50),
							.iRST(KEY[0]),
							.oRST_0(DLY_RST_0),
							.oRST_1(DLY_RST_1),
							.oRST_2(DLY_RST_2)
						);

CCD_Capture			u3	(	.oDATA(mCCD_DATA),
							.oDVAL(mCCD_DVAL),
							.oX_Cont(X_Cont),
							.oY_Cont(Y_Cont),
							.oFrame_Cont(Frame_Cont),
							.iDATA(rCCD_DATA),
							.iFVAL(rCCD_FVAL),
							.iLVAL(rCCD_LVAL),
							.iSTART(!KEY[3]),
							.iEND(!KEY[2]),
							.iCLK(CCD_PIXCLK),
							.iRST(DLY_RST_2)
						);

//RAW2RGB				u4	(	.iCLK(CCD_PIXCLK),
//							.iRST(DLY_RST_1),
//							.iDATA(mCCD_DATA),
//							.iDVAL(mCCD_DVAL),
//							.oRed(sCCD_R),
//							.oGreen(sCCD_G),
//							.oBlue(sCCD_B),
//							.oDVAL(sCCD_DVAL),
//							.iX_Cont(X_Cont),
//							.iY_Cont(Y_Cont)
//						);

SEG7_LUT_8 			u5	(	.oSEG0(HEX0),.oSEG1(HEX1),
							.oSEG2(HEX2),.oSEG3(HEX3),
							.oSEG4(HEX4),.oSEG5(HEX5),
							.iDIG(Frame_Cont[31:0])
						);


assign CCD_MCLK = rClk[0];

I2C_CCD_Config 		u8	(	//	Host Side
							.iCLK(CLOCK_50),
							.iRST_N(DLY_RST_2),
							.iZOOM_MODE_SW(SW[9]),
							.iEXPOSURE_ADJ(KEY[1]),
							.iEXPOSURE_DEC_p(SW[0]),
							//	I2C Side
							.I2C_SCLK(GPIO_1[24]),
							.I2C_SDAT(GPIO_1[23])
						);

						
						
						
						
						
						
						
						
wire [15:0] cameraAddress, imageAddress;
wire [1:0] 	cameraOffset;
wire [7:0] pixelData;
wire 			validPixel, readMemory;
wire [31:0]	memoryDataOut;
reg  [15:0] tempAddress;
reg  [31:0] pixelBuffer, memoryData;
reg			fullBuffer, writeEnable;

assign cameraAddress = {Y_Cont[8:0],X_Cont[8:2]};
assign cameraOffset = X_Cont[1:0];
assign pixelData = mCCD_DATA[11:4];
assign validPixel = mCCD_DVAL;
//assign imageAddress = HPS_DATA[16:1];
//assign readMemory = HPS_DATA[0] & !validPixel;
assign muxAddress = tempAddress;

assign DATA0 = memoryDataOut[31:0];
//assign DATA1 = memoryDataOut[32+:16];
//assign DATA2 = memoryDataOut[32*2+:32];







//vgaMemory cameraMemory(
//	muxAddress,
//	CCD_PIXCLK,
//	memoryData,
//	writeEnable,
//	memoryDataOut
//);	


always @(posedge CCD_PIXCLK) begin

	//BUFFER LOGIC
	if (!validPixel || X_Cont[9]) begin
		pixelBuffer <= 0;
		fullBuffer <= 0;
	end
	else begin
		case (cameraOffset)
			0: begin
				pixelBuffer[cameraOffset*8 +: 8] <= pixelData;
				fullBuffer <= 0;
			end
			1: pixelBuffer[cameraOffset*8 +: 8] <= pixelData;
			2: pixelBuffer[cameraOffset*8 +: 8] <= pixelData;
			3: begin
				memoryData[cameraOffset*8 +: 8] <= pixelData;
				memoryData[23:0] <= pixelBuffer[23:0];
				fullBuffer <= 1;	
				tempAddress <= cameraAddress;				
			end
			
			default: begin
				pixelBuffer <= 0;
				fullBuffer <= 0;
			end
			
		endcase	
	end


	//MEMORY LOGIC
	if (fullBuffer || (writeEnable & cameraOffset < 3)) begin
		writeEnable <= 1;
	end 
	else begin
		writeEnable <= 0;
	end


end




















//camera cameraMemory(
//	muxAddress,
//	CCD_PIXCLK,
//	CCD_PIXCLK,
//	memoryData,
//	writeEnable,
//	memoryDataOut
//);	
//
//
//always @(posedge CCD_PIXCLK) begin
//
//	//BUFFER LOGIC
//	if (!validPixel) begin
//		pixelBuffer <= 0;
//		fullBuffer <= 0;
//	end
//	else begin
//		case (cameraOffset)
//			0: begin
//				pixelBuffer[cameraOffset*12 +: 12] <= validPixel;
//				fullBuffer <= 0;
//			end
//			1: pixelBuffer[cameraOffset*12 +: 12] <= validPixel;
//			2: pixelBuffer[cameraOffset*12 +: 12] <= validPixel;
//			3: pixelBuffer[cameraOffset*12 +: 12] <= validPixel;
//			4: pixelBuffer[cameraOffset*12 +: 12] <= validPixel;
//			5: pixelBuffer[cameraOffset*12 +: 12] <= validPixel;
//			6: pixelBuffer[cameraOffset*12 +: 12] <= validPixel;
//			7: begin
//				memoryData[cameraOffset*12 +: 12] <= validPixel;
//				memoryData[83:0] <= pixelBuffer[83:0];
//				fullBuffer <= 1;
//				tempAddress <= cameraAddress;				
//			end
//			
//			default: begin
//				pixelBuffer <= 0;
//				fullBuffer <= 0;
//			end
//			
//		endcase	
//	end
//
//
//	//MEMORY LOGIC
//	if (fullBuffer || (writeEnable & cameraOffset < 3)) begin
//		writeEnable <= 1;
//	end 
//	else begin
//		writeEnable <= 0;
//	end
//
//
//end



		
endmodule