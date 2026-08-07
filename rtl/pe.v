module pe (
    input clk,
    input rst,

    input [7:0] a_in,
    input [7:0] b_in,

    output reg [7:0] a_out,
    output reg [7:0] b_out,

    output reg [15:0] result
);

always @(posedge clk) begin
    if (rst) begin
        result <= 16'd0;
        a_out  <= 8'd0;
        b_out  <= 8'd0;
    end
    else begin
        a_out <= a_in;
        b_out <= b_in;

        result <= result + (a_in * b_in);
    end
end

endmodule