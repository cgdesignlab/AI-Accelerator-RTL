`timescale 1ns/1ps

module systolic_array #(
    parameter int N          = 4,
    parameter int DATA_WIDTH = 8,
    parameter int ACC_WIDTH  = 32
)(
    input  logic clk,
    input  logic rst,

    input  logic signed [DATA_WIDTH-1:0] a_in [0:N-1],
    input  logic signed [DATA_WIDTH-1:0] b_in [0:N-1],

    output logic signed [ACC_WIDTH-1:0] result [0:N-1][0:N-1]
);

    logic signed [DATA_WIDTH-1:0] a_bus [0:N-1][0:N];
    logic signed [DATA_WIDTH-1:0] b_bus [0:N][0:N-1];

    genvar i;

    generate
        for (i = 0; i < N; i++) begin : INPUT_A
            assign a_bus[i][0] = a_in[i];
        end
    endgenerate

    generate
        for (i = 0; i < N; i++) begin : INPUT_B
            assign b_bus[0][i] = b_in[i];
        end
    endgenerate

    genvar row, col;

    generate
        for (row = 0; row < N; row++) begin : ROW
            for (col = 0; col < N; col++) begin : COL

                pe #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .ACC_WIDTH(ACC_WIDTH)
                ) u_pe (
                    .clk(clk),
                    .rst(rst),
                    .a_in (a_bus[row][col]),
                    .b_in (b_bus[row][col]),
                    .a_out(a_bus[row][col+1]),
                    .b_out(b_bus[row+1][col]),
                    .result(result[row][col])
                );

            end
        end
    endgenerate

endmodule
