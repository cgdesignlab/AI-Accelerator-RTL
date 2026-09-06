`timescale 1ns/1ps

module ai_accelerator_top #(
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

    //==========================================================
    // Systolic Array Instantiation
    //==========================================================

    systolic_array #(
        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) u_systolic_array (

        .clk(clk),
        .rst(rst),

        .a_in(a_in),
        .b_in(b_in),

        .result(result)

    );

endmodule