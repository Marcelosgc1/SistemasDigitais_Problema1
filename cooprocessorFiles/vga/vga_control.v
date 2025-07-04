module vga_control(
	input [1:0]sw_debug,
	input [17:0]address, 
	input clk,
	input write_result,
	input [7:0]new_data,
	input [31:0] ram_data,
	output reg done,
	output [15:0] addr,
	output reg [31:0] data_in,
	output reg WRITE_ENABLE,
	output hsync, 
	output vsync,
	output [7:0]red,
	output [7:0]green,
	output [7:0]blue,
	output vga_sync,
	output vga_clk,
	output vga_blank
);


wire [9:0] x, y;
reg [7:0] color;
wire [1:0] offset;
reg MHz25;
reg [3:0]count;
wire [7:0] pixel_color;


assign offset = write_result ? address[1:0] : sw_debug[0] ? x[1:0] : y[1:0];
assign addr = write_result ? address[17:2] : sw_debug[0] ? {y[8:0],x[8:2]} : {x[8:0],y[8:2]};
assign pixel_color = (x[9]||y[9]) ? 0 : color;

	 
	 
vga_driver(
	MHz25,
	0,
	pixel_color, 
	x, 
	y,
	hsync,
	vsync,
	red,
	green,
	blue,
	vga_sync,
	vga_clk,
	vga_blank
);
	
	
always @(*) begin
    case (offset)
        0: begin
            color   = sw_debug[1] ? ram_data[31:24] : ram_data[7:0];
        end
        1: begin
            color   = sw_debug[1] ? ram_data[23:16] : ram_data[15:8];
        end
        2: begin
            color   = sw_debug[1] ? ram_data[15:8] : ram_data[23:16];
        end
        3: begin
            color   = sw_debug[1] ? ram_data[7:0] : ram_data[31:24];
        end
        default: begin
            color   = 0;
        end
    endcase
end

	
	

always @(posedge clk) begin
    MHz25 <= ~MHz25;

    if (!write_result) begin
        done <= 0;
        count <= 0;
        WRITE_ENABLE <= 0;
    end
    else begin
        case (count)
            0: begin
                WRITE_ENABLE <= 0;
                count <= 1;
            end

            1: begin
                count <= 2;
            end

            2: begin
                case (offset)
                    0: data_in <= {ram_data[31:8], new_data};
                    1: data_in <= {ram_data[31:16], new_data, ram_data[7:0]};
                    2: data_in <= {ram_data[31:24], new_data, ram_data[15:0]};
                    3: data_in <= {new_data, ram_data[23:0]};
                endcase
                count <= 3;
            end

            3: begin
                WRITE_ENABLE <= 1;
                count <= 4;
            end

            4: begin
                WRITE_ENABLE <= 0;
                done <= 1;
                count <= 0;
            end
        endcase
    end
end




	
	 
endmodule