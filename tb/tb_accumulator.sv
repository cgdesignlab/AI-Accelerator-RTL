`timescale 1ns/1ps

module tb_accumulator;

reg clk;
reg rst;
reg [15:0] in;

wire [15:0] sum;

// Instantiate accumulator
accumulator uut (
    .clk(clk),
    .rst(rst),
    .in(in),
    .sum(sum)
);

// Generate Clock
always #5 clk = ~clk;

// Dump waveform
initial begin
    $dumpfile("waveforms/accumulator.vcd");
    $dumpvars(0, tb_accumulator);
end

// Apply Test Cases
initial begin

    $display("Starting Accumulator Test...");
    $monitor("Time=%0t | rst=%b | in=%d | sum=%d",
              $time, rst, in, sum);

    clk = 0;
    rst = 1;
    in = 0;

    #10;

    rst = 0;

    in = 5;
    #10;

    in = 10;
    #10;

    in = 3;
    #10;

    in = 8;
    #10;

    in = 20;
    #10;

    $finish;

end

endmodule