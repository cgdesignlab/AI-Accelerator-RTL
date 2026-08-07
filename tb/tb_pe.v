`timescale 1ns/1ps

module tb_pe;

reg clk;
reg rst;
reg [7:0] a_in;
reg [7:0] b_in;

wire [7:0] a_out;
wire [7:0] b_out;
wire [15:0] result;

// Instantiate DUT
pe uut (
    .clk(clk),
    .rst(rst),
    .a_in(a_in),
    .b_in(b_in),
    .a_out(a_out),
    .b_out(b_out),
    .result(result)
);

// Clock generation
always #5 clk = ~clk;

// Waveform dump
initial begin
    $dumpfile("waveforms/pe.vcd");
    $dumpvars(0, tb_pe);
end

// Test sequence
initial begin

    clk = 0;
    rst = 1;

    a_in = 0;
    b_in = 0;

    #10;

    rst = 0;

    //------------------------
    // Test 1
    //------------------------
    a_in = 2;
    b_in = 3;

    #10;

    //------------------------
    // Test 2
    //------------------------
    a_in = 4;
    b_in = 5;

    #10;

    //------------------------
    // Test 3
    //------------------------
    a_in = 1;
    b_in = 6;

    #10;

    //------------------------
    // Test 4
    //------------------------
    a_in = 8;
    b_in = 8;

    #10;

    $finish;

end

// Monitor

initial begin
    $monitor(
        "Time=%0t | A=%d B=%d | A_out=%d B_out=%d | Result=%d",
        $time,
        a_in,
        b_in,
        a_out,
        b_out,
        result
    );
end

endmodule