`timescale 1ns/1ps

module tb_multiplier;

reg [7:0] a;
reg [7:0] b;

wire [15:0] product;

multiplier uut (
    .a(a),
    .b(b),
    .product(product)
);

initial begin
    $dumpfile("waveforms/multiplier.vcd");
    $dumpvars(0, tb_multiplier);
end

initial begin

    $display("Running NEW testbench...");

    $monitor("Time=%0t ns | a=%0d | b=%0d | product=%0d",
              $time, a, b, product);

    a = 0;   b = 0;     #10;
    a = 1;   b = 1;     #10;
    a = 0;   b = 255;   #10;
    a = 255; b = 0;     #10;
    a = 255; b = 1;     #10;
    a = 1;   b = 255;   #10;
    a = 5;   b = 10;    #10;
    a = 15;  b = 3;     #10;
    a = 255; b = 255;   #10;

    $finish;

end

endmodule