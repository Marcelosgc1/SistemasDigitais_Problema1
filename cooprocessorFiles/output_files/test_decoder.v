module test_decoder(
input [2:0]lin,
input [2:0]col,
input [1:0]id,
input sw9,
input sw8,
output [7:0] leds
);

wire [31:0] t;
wire [3:0]opcode;
wire [7:0]adrs;
wire [15:0] data;
assign t[3:0] = 4'b0010;
assign t[6:4] = lin;
assign t[9:7] = col;
assign t[11:10] = id;
assign t[20:12] = 9'b111111111;
decoder(t,opcode,adrs,data);

assign leds = sw9 ? adrs : (sw8 ? opcode : data);

endmodule
