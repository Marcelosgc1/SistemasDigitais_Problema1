module matriz_soma(
    input [255:0] q_a,
    input [255:0] q_b,
    output wire [255:0] data_c
);

    genvar i;
    generate
        for (i = 0; i < 256; i = i + 8) begin : soma_matrizes
            assign data_c[i +: 8] = q_a[i +: 8] + q_b[i +: 8];
        end
    endgenerate

endmodule
