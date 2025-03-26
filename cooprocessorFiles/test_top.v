module test_top(
	input clk,
	input sw1,
	output [7:0]leds
);

top(17'b10001000000000010, sw1, clk, leds);
debounce(b,clk,c);












endmodule