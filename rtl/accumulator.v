module accumulator(

    input clk,
    input rst,

    input [15:0] in,

    output reg [15:0] sum

);

always @(posedge clk)

begin

    if(rst)

        sum <= 16'd0;

    else

        sum <= sum + in;

end

endmodule