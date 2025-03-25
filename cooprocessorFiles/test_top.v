module test_top(
	input clk,
	input sw0,
	input sw1,
	input b,
	output [7:0]leds
);

top(32'b11011000000000010, sw1, c, leds);
debounce(b,clk,c);












endmodule