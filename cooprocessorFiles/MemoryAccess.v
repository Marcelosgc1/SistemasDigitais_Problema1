module MemoryAccess (
    input clk,           
    input reset,         
    output reg [7:0] data_out0,  
    output reg [7:0] data_out1,   
    output reg done             
);

	 // Aqui executou declarando dessa maneira, não deu problema do SystemVerilog
    reg [7:0] matrizA [0:24];
	 reg [7:0] matrizB [0:24];	 
    reg [4:0] addr;        
    integer i;

 
	// Aqui to preenchendo a matriz A com valores múltiplos de 2 e a matriz B com múltiplos de 3
    initial begin
        for (i = 0; i < 25; i = i + 1)
            matrizA[i] = i * 2;
				matrizB[i] = i * 3;		
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            addr <= 0;   // Reinicia a leitura
            done <= 0;
        end else begin
            if (addr < 25) begin
                data_out0 <= matrizA[addr];
                data_out1 <= matrizB[addr + 1];                
                addr <= addr + 2;  // Avança para o próximo bloco
            end else begin
                done <= 1;  // Indica fim da leitura
            end
        end
    end

endmodule
