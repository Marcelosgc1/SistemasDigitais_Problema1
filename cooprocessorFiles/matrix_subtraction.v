module matrix_subtraction(
    input [255:0] q_a,
    input [255:0] q_b,
    output wire [255:0] data_c
);

    genvar i;
    generate
        for (i = 0; i < 256; i = i + 8) begin : sub_matrix
            assign data_c[i+7:i] = q_a[i+7:i] - q_b[i+7:i];
        end
    endgenerate

endmodule
