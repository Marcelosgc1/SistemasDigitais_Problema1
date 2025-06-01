//MULTIPLICAÇAO 20 ADP BLOCK

module matriz_conv (
  input [199:0] matriz_a, // Matriz A (5x5, 8 bits por elemento)
  input signed [199:0] matriz_b, // Matriz B (5x5, 8 bits por elemento)
  input clk,
  input start,
  output [7:0] result, 
  output signal,
  output reg done
);
	
  reg signed [15:0] mult [0:24];
  reg signed [16:0] stage1 [0:12];
  reg signed [17:0] stage2 [0:6];
  reg signed [18:0] stage3 [0:3];
  reg signed [19:0] stage4 [0:1];
  reg signed [20:0] final_sum;
  

  reg [2:0]  stage;
  reg [20:0] modulo;
  
  assign result = (|modulo[20:8]) ? 8'hff : modulo[7:0];
  assign signal = final_sum[20]; 
  
  integer i;

  always @(posedge clk) begin
    if (!start) begin
      stage <= 0;
      done <= 0;
    end else begin
      case (stage)
        0: begin
          for (i = 0; i < 25; i = i + 1) begin
            mult[i] <= $signed(matriz_b[i*8 +: 8]) * matriz_a[i*8 +: 8];
          end
          stage <= 1;
          done <= 0;
        end

        1: begin
          for (i = 0; i < 12; i = i + 1)
            stage1[i] <= mult[2*i] + mult[2*i+1];
          stage1[12] <= mult[24]; 
          stage <= 2;
        end

        2: begin
          for (i = 0; i < 6; i = i + 1)
            stage2[i] <= stage1[2*i] + stage1[2*i+1];
          stage2[6] <= stage1[12];
          stage <= 3;
        end

        3: begin
          for (i = 0; i < 3; i = i + 1)
				stage3[i] <= stage2[2*i] + stage2[2*i+1];
				stage3[3] <= stage2[6];
          stage <= 4;
        end

        4: begin
          stage4[0] <= stage3[0] + stage3[1];
          stage4[1] <= stage3[2] + stage3[3];
          stage <= 5;
        end

        5: begin
          final_sum <= stage4[0] + stage4[1];
          stage <= 6;
        end

        6: begin
          modulo <= final_sum[20] ? (~final_sum + 1'b1) : final_sum;
          done <= 1;
          stage <= 6;
        end
      endcase
    end
  end

endmodule
