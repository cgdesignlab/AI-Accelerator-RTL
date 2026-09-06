`timescale 1ns/1ps

module tb_ai_accelerator_top;

parameter int N          = 4;
parameter int DATA_WIDTH = 8;
parameter int ACC_WIDTH  = 32;

logic clk;
logic rst;

logic signed [DATA_WIDTH-1:0] a_in [0:N-1];
logic signed [DATA_WIDTH-1:0] b_in [0:N-1];
logic signed [ACC_WIDTH-1:0]  result [0:N-1][0:N-1];

logic signed [DATA_WIDTH-1:0] A [0:N-1][0:N-1];
logic signed [DATA_WIDTH-1:0] B [0:N-1][0:N-1];
logic signed [ACC_WIDTH-1:0]  expected [0:N-1][0:N-1];

int cyc;
int errors;

ai_accelerator_top #(
    .N(N),
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
) dut (
    .clk(clk),
    .rst(rst),
    .a_in(a_in),
    .b_in(b_in),
    .result(result)
);

always #5 clk = ~clk;

// Synchronous cycle counter — drives the skewed feed schedule
always_ff @(posedge clk or posedge rst) begin
    if (rst) cyc <= 0;
    else     cyc <= cyc + 1;
end

// Skewed feed: row r of A delayed by r cycles, column c of B delayed by c cycles.
// Required because a_in/b_in expect one staggered element per PE per cycle,
// not a full row/column at once — see design note on matrix_engine integration.
always_comb begin
    for (int r = 0; r < N; r++)
        a_in[r] = (cyc >= r && cyc < r+N) ? A[r][cyc-r] : '0;
    for (int c = 0; c < N; c++)
        b_in[c] = (cyc >= c && cyc < c+N) ? B[cyc-c][c] : '0;
end

initial begin
    $dumpfile("waveforms/ai_accelerator_top.vcd");
    $dumpvars(0, tb_ai_accelerator_top);
    $dumpvars(0, dut.u_systolic_array.ROW[0].COL[0].u_pe.result);
    $dumpvars(0, dut.u_systolic_array.ROW[1].COL[1].u_pe.result);
    $dumpvars(0, dut.u_systolic_array.ROW[2].COL[2].u_pe.result);
    $dumpvars(0, dut.u_systolic_array.ROW[3].COL[3].u_pe.result);
end

initial begin
    // Matrix A, row by row
    A[0][0]=1;  A[0][1]=2;  A[0][2]=3;  A[0][3]=4;
    A[1][0]=5;  A[1][1]=6;  A[1][2]=7;  A[1][3]=8;
    A[2][0]=9;  A[2][1]=10; A[2][2]=11; A[2][3]=12;
    A[3][0]=13; A[3][1]=14; A[3][2]=15; A[3][3]=16;

    // Matrix B, row by row
    B[0][0]=1;  B[0][1]=2;  B[0][2]=3;  B[0][3]=4;
    B[1][0]=5;  B[1][1]=6;  B[1][2]=7;  B[1][3]=8;
    B[2][0]=9;  B[2][1]=10; B[2][2]=11; B[2][3]=12;
    B[3][0]=13; B[3][1]=14; B[3][2]=15; B[3][3]=16;

    // Reference model
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++) begin
            expected[i][j] = 0;
            for (int k = 0; k < N; k++)
                expected[i][j] += A[i][k] * B[k][j];
        end

    clk = 0;
    rst = 1;
    #20;
    rst = 0;

    repeat (3*N + 5) @(posedge clk);

    errors = 0;
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++) begin
            if (result[i][j] !== expected[i][j]) begin
                $display("FAIL: C[%0d][%0d]=%0d expected %0d", i, j, result[i][j], expected[i][j]);
                errors = errors + 1;
            end
        end

    if (errors == 0)
        $display("PASS: All 16 outputs match expected matrix product.");
    else
        $display("%0d MISMATCH(ES) FOUND", errors);

    $finish;
end

endmodule
