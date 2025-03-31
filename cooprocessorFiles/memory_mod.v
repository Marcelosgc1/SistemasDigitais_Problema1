module memory_mod (  
    input wire [7:0] address,  
    input wire [15:0] data_in,  
    input wire start,  
    input wire wr,  
    input wire clk,  

    output reg [15:0] data_out,  
    output reg done  
);  

    reg [2:0] count;  
    wire [15:0] ram_data_out;  

    ram16bits (  
        address,  
        clk,  
        data_in,  
        wr,  
        ram_data_out
    );

	always @(posedge clk) begin  
		if (start) begin
			if (wr) begin 
				if (count < 3) begin  
					count <= count + 1;  
					done <= 0;  
				end else begin  
					done <= 1;  
				end
			end else begin  
				data_out <= ram_data_out;  
				done <= 1;  
			end
		end else begin  
			count <= 0;  
			done <= 0;  
		end  
	end  

endmodule