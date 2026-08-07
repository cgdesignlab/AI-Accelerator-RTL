`timescale 1ns/1ps

module tb_mac;

reg clk;
reg rst;
reg [7:0] a;
reg [7:0] b;

wire [15:0] sum;
wire [15:0] product;

assign product = a * b;
// Instantiate MAC
mac uut (
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .sum(sum)
);

// Clock generation
always #5 clk = ~clk;

// Waveform dump
initial begin
    $dumpfile("waveforms/mac.vcd");
    $dumpvars(0, tb_mac);
end

// Test sequence
initial begin

    $display("Starting MAC Test...");
    $monitor("Time=%0t | a=%d b=%d product=%d sum=%d",
         $time, a, b, product, sum);

    clk = 0;
    rst = 1;
    a = 0;
    b = 0;

    #10;
    rst = 0;

    a = 2;  b = 3;   #10;
    a = 5;  b = 4;   #10;
    a = 10; b = 2;   #10;
    a = 7;  b = 5;   #10;
    a = 8;  b = 8;   #10;

    $finish;

end

endmodule