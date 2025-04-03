module decod7seg(input [3:0] num, output [6:0] seg);

wire a,b,c,d;

assign a = num[3];
assign b = num[2];
assign c = num[1];
assign d = num[0];


assign seg[0] = (!a&!b&!c&d) +
(!a&b&!c&!d) +
(a&!b&c&d) +
(a&b&!c&d);

assign seg[1] = (b&c&!d) + 
(a&c&d) +
(a&b&!d) +
(!a&b&!c&d);

assign seg[2] = (a&b&!d) +
(a&b&c) +
(!a&!b&c&!d);

assign seg[3] = (b&c&d) + 
(!a&!b&!c&d) + 
(!a&b&!c&!d) +
(a&!b&c&!d);

assign seg[4] = (!a&d) +
(!b&!c&d) +
(!a&b&!c);

assign seg[5] = (!a&!b&d) + 
(!a&!b&c) +
(!a&c&d) +
(a&b&!c&d);

assign seg[6] = !(a+b+c) + 
(!a&b&c&d) +
(a&b&!c&!d);

endmodule