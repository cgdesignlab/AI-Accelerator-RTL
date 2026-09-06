`timescale 1ns/1ps

module tb_pe;

parameter DATA_WIDTH = 8;
parameter ACC_WIDTH  = 32;

logic clk, rst;
logic signed [DATA_WIDTH-1:0] a_in, b_in;
logic signed [DATA_WIDTH-1:0] a_out, b_out;
logic signed [ACC_WIDTH-1:0]  result;

pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) uut (
    .clk(clk), .rst(rst),
    .a_in(a_in), .b_in(b_in),
    .a_out(a_out), .b_out(b_out),
    .result(result)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("waveforms/pe.vcd");
    $dumpvars(0, tb_pe);
end

initial begin
    $monitor("Time=%0t | A=%d B=%d | A_out=%d B_out=%d | Result=%d",
              $time, a_in, b_in, a_out, b_out, result);

    clk = 0; rst = 1;
    a_in = 0; b_in = 0;
    #10;
    rst = 0;

    a_in = 2;  b_in = 3;  #10;
    a_in = -4; b_in = 5;  #10;   // negative operand check
    a_in = 1;  b_in = 6;  #10;
    a_in = 8;  b_in = 8;  #10;

    $finish;
end

endmodule
