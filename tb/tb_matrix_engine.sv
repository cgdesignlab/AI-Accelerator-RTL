`timescale 1ns/1ps

module tb_matrix_engine;

    //------------------------------------------------------------
    // Parameters
    //------------------------------------------------------------
    localparam DATA_WIDTH = 32;
    localparam SIZE       = 4;

    //------------------------------------------------------------
    // DUT Signals
    //------------------------------------------------------------
    logic clk;
    logic rst;
    logic start;

    logic [DATA_WIDTH-1:0] matrix_a [SIZE][SIZE];
    logic [DATA_WIDTH-1:0] matrix_b [SIZE][SIZE];

    logic [DATA_WIDTH-1:0] row_data [SIZE];
    logic [DATA_WIDTH-1:0] col_data [SIZE];

    logic done;

    //------------------------------------------------------------
    // Expected Data
    //------------------------------------------------------------
    logic [DATA_WIDTH-1:0] expected_rows [SIZE][SIZE];
    logic [DATA_WIDTH-1:0] expected_cols [SIZE][SIZE];

    //------------------------------------------------------------
    // Pass / Fail Counters
    //------------------------------------------------------------
    integer pass_count;
    integer fail_count;

    integer i;
    integer j;

    //------------------------------------------------------------
    // DUT
    //------------------------------------------------------------
    matrix_engine #(
        .DATA_WIDTH(DATA_WIDTH),
        .SIZE(SIZE)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),

        .matrix_a(matrix_a),
        .matrix_b(matrix_b),

        .row_data(row_data),
        .col_data(col_data),

        .done(done)
    );

    //------------------------------------------------------------
    // Clock Generation
    //------------------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //------------------------------------------------------------
    // Waveform Dump
    //------------------------------------------------------------
    initial begin
        $dumpfile("waveforms/matrix_engine.vcd");
        $dumpvars(0, tb_matrix_engine);
    end

    //------------------------------------------------------------
    // Reset Task
    //------------------------------------------------------------
    task automatic apply_reset;

        begin

            rst   = 1;
            start = 0;

            repeat (2) @(posedge clk);

            rst = 0;

            @(posedge clk);

        end

    endtask

    //------------------------------------------------------------
    // Start Pulse Task
    //------------------------------------------------------------
    task automatic pulse_start;

    begin

        start = 1;
        @(posedge clk);
        #1;              // let the DUT's always_ff sample start=1 before we drop it
        start = 0;

    end

endtask

    //------------------------------------------------------------
    // Initialize Matrices
    //------------------------------------------------------------
    task automatic initialize_matrices;

        begin

            matrix_a[0][0]=1;
            matrix_a[0][1]=2;
            matrix_a[0][2]=3;
            matrix_a[0][3]=4;

            matrix_a[1][0]=5;
            matrix_a[1][1]=6;
            matrix_a[1][2]=7;
            matrix_a[1][3]=8;

            matrix_a[2][0]=9;
            matrix_a[2][1]=10;
            matrix_a[2][2]=11;
            matrix_a[2][3]=12;

            matrix_a[3][0]=13;
            matrix_a[3][1]=14;
            matrix_a[3][2]=15;
            matrix_a[3][3]=16;

            matrix_b[0][0]=101;
            matrix_b[0][1]=102;
            matrix_b[0][2]=103;
            matrix_b[0][3]=104;

            matrix_b[1][0]=105;
            matrix_b[1][1]=106;
            matrix_b[1][2]=107;
            matrix_b[1][3]=108;

            matrix_b[2][0]=109;
            matrix_b[2][1]=110;
            matrix_b[2][2]=111;
            matrix_b[2][3]=112;

            matrix_b[3][0]=113;
            matrix_b[3][1]=114;
            matrix_b[3][2]=115;
            matrix_b[3][3]=116;

        end

    endtask

    //------------------------------------------------------------
    // Build Expected Arrays
    //------------------------------------------------------------
    task automatic build_expected_data;

        begin

            for(i=0;i<SIZE;i=i+1) begin

                for(j=0;j<SIZE;j=j+1) begin

                    expected_rows[i][j] = matrix_a[i][j];
                    expected_cols[i][j] = matrix_b[j][i];

                end

            end

        end

    endtask

    //------------------------------------------------------------
    // Reset Verification
    //------------------------------------------------------------
    task automatic verify_reset;

        integer k;

        begin

            #1;   // let DUT's NBA updates settle before sampling

            $display("\n-----------------------------------------");
            $display("Checking Reset...");
            $display("-----------------------------------------");

            for(k=0;k<SIZE;k=k+1) begin

                if(row_data[k]!==0) begin
                    $display("FAIL : row_data[%0d] not reset",k);
                    fail_count++;
                end
                else
                    pass_count++;

                if(col_data[k]!==0) begin
                    $display("FAIL : col_data[%0d] not reset",k);
                    fail_count++;
                end
                else
                    pass_count++;

            end

            if(done!==0) begin
                $display("FAIL : done not reset");
                fail_count++;
            end
            else
                pass_count++;

        end

    endtask

    //------------------------------------------------------------
    // Stream Verification
    //------------------------------------------------------------
    task automatic verify_stream;

        input integer cycle;

        integer k;

        begin

            @(posedge clk);

            #1;

            $display("-----------------------------------------");
            $display("Checking Stream Cycle %0d",cycle);
            $display("-----------------------------------------");

            for(k=0;k<SIZE;k=k+1) begin

                if(row_data[k]!==expected_rows[cycle][k]) begin

                    $display("FAIL Row[%0d] Expected=%0d Got=%0d",
                        k,
                        expected_rows[cycle][k],
                        row_data[k]);

                    fail_count++;

                end
                else begin

                    pass_count++;

                end

                if(col_data[k]!==expected_cols[cycle][k]) begin

                    $display("FAIL Col[%0d] Expected=%0d Got=%0d",
                        k,
                        expected_cols[cycle][k],
                        col_data[k]);

                    fail_count++;

                end
                else begin

                    pass_count++;

                end

            end

        end

    endtask

    //------------------------------------------------------------
    // Done Verification
    //------------------------------------------------------------
    task automatic verify_done;

        begin

            @(posedge clk);

            #1;

            if(done==1'b1) begin

                pass_count++;
                $display("PASS : Done pulse detected");

            end
            else begin

                fail_count++;
                $display("FAIL : Done pulse missing");

            end

            @(posedge clk);

            #1;

            if(done==1'b0) begin

                pass_count++;
                $display("PASS : Done deasserted");

            end
            else begin

                fail_count++;
                $display("FAIL : Done wider than one clock");

            end

        end

    endtask

    //------------------------------------------------------------
    // Test Sequence
    //------------------------------------------------------------
    initial begin

        pass_count = 0;
        fail_count = 0;
        $monitor("T=%0t rst=%b start=%b state=%0d cyc=%0d done=%b",
                  $time, rst, start, dut.current_state, dut.cycle_count, done);


        initialize_matrices();

        build_expected_data();

        apply_reset();

        verify_reset();

        pulse_start();

        for(i=0;i<SIZE;i=i+1)
            verify_stream(i);

        verify_done();

        $display("\n=========================================");
        $display(" MATRIX ENGINE VERIFICATION SUMMARY");
        $display("=========================================");
        $display("PASS COUNT = %0d",pass_count);
        $display("FAIL COUNT = %0d",fail_count);

        if(fail_count==0)

            $display("OVERALL RESULT : PASS");

        else

            $display("OVERALL RESULT : FAIL");

        $display("=========================================\n");

        #20;

        $finish;

    end

endmodule
