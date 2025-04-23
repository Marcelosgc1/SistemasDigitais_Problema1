module matriz_determ4x4 (
    input wire [199:0] matriz_A, // Matriz 5x5 em vetor
    input clk,
    input start,
    output reg done, // Indica fim do cálculo
    output reg [7:0] det, // Determinante 4x4
	 output overflow
);

    wire [7:0] mat [4:0][4:0]; // Matriz 5x5
    reg [33:0] tp [3:0]; // Termos temporários
    genvar i, j;
    reg [4:0] count = 0; // Contador
	 wire [36:0] temp;
	 
    function [25:0] det_3x3; // Função para determinante 3x3
        input [7:0] a, b, c, d, e, f, g, h, i;
        begin
            det_3x3 = a * (e * i - f * h) -
                      b * (d * i - f * g) +
                      c * (d * h - e * g);
        end
    endfunction

    generate begin
        for (i = 0; i < 5; i = i + 1) begin : adad
            for (j = 0; j < 5; j = j + 1) begin : asdasd
                assign mat[i][j] = matriz_A[(i * 40) + (j * 8) +: 8]; // Conversão vetor para matriz
            end
        end
    end endgenerate
	 
	 assign temp = tp[0] - tp[1] + tp[2] - tp[3]; // Soma dos cofatores
	 assign overflow = !(!(|temp[36:7]) | (&temp[36:7]));
	 
    always @(posedge clk) begin
        if(start) begin
            if (count < 4) begin
                tp[count] = mat[0][count] * det_3x3(
                    mat[1][(count+1)%4], mat[1][(count+2)%4], mat[1][(count+3)%4],
                    mat[2][(count+1)%4], mat[2][(count+2)%4], mat[2][(count+3)%4],
                    mat[3][(count+1)%4], mat[3][(count+2)%4], mat[3][(count+3)%4]
                ); // Expansão por cofatores
            end else begin
					 det = temp[7:0];
                done = 1;
            end

            count <= count + 1;
        end else begin
            done = 0;
            det = 0;
            count = 0;
        end
    end
endmodule