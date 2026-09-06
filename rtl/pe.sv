`timescale 1ns/1ps

module pe #(
    parameter int DATA_WIDTH = 8,
    parameter int ACC_WIDTH  = 32
)(
    input  logic clk,
    input  logic rst,

    input  logic signed [DATA_WIDTH-1:0] a_in,
    input  logic signed [DATA_WIDTH-1:0] b_in,

    output logic signed [DATA_WIDTH-1:0] a_out,
    output logic signed [DATA_WIDTH-1:0] b_out,

    output logic signed [ACC_WIDTH-1:0]  result
);

always_ff @(posedge clk) begin
    if (rst) begin
        result <= '0;
        a_out  <= '0;
        b_out  <= '0;
    end
    else begin
        a_out  <= a_in;
        b_out  <= b_in;
        result <= result + (a_in * b_in);
    end
end

endmodule
