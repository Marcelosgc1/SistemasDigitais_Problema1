module load(
	input start,
	input rst,
	output [3:0] opcode,
	output reg loading,
	output reg [7:0] adrs,
	output reg done
);
	reg flag;
	assign opcode = 1;
	always @(posedge start or posedge rst) begin
		if (rst) begin
			flag = 0;
			loading <= 0;
			adrs <= 0;
			done <= 0;
		end else	if (!flag) begin
			flag = 1;
			loading <= 1;
		end else if (adrs[3:0] < 12) begin
			adrs[3:0] <= adrs[3:0] + 1;
			loading <= 1;
		end else if (!adrs[4]) begin
			adrs[4] <= 1;
			adrs[3:0] <= 0;
			flag <= 0;
			loading <= 1;
		end else begin
			loading <= 0;
			done <= 1;
		end		
	end


endmodule