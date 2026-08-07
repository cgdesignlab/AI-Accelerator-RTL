module mac(

    input clk,
    input rst,

    input [7:0] a,
    input [7:0] b,

    output [15:0] sum

);

wire [15:0] product;

// Instantiate Multiplier
multiplier mult(

    .a(a),
    .b(b),
    .product(product)

);

// Instantiate Accumulator
accumulator acc(

    .clk(clk),
    .rst(rst),
    .in(product),
    .sum(sum)

);

endmodule