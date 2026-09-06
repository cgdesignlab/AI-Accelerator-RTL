`timescale 1ns/1ps

module matrix_engine #(
    parameter DATA_WIDTH = 32,
    parameter SIZE       = 4
)(
    input  logic clk,
    input  logic rst,
    input  logic start,

    input  logic [DATA_WIDTH-1:0] matrix_a [SIZE][SIZE],
    input  logic [DATA_WIDTH-1:0] matrix_b [SIZE][SIZE],

    output logic [DATA_WIDTH-1:0] row_data [SIZE],
    output logic [DATA_WIDTH-1:0] col_data [SIZE],

    output logic done
);

    //------------------------------------------------------------
    // State Encoding
    //------------------------------------------------------------
    typedef enum logic [1:0] {
        IDLE,
        STREAM,
        DONE
    } state_t;

    state_t current_state;

    //------------------------------------------------------------
    // Cycle Counter
    //------------------------------------------------------------
    logic [$clog2(SIZE):0] cycle_count;

    integer i;

    //------------------------------------------------------------
    // Sequential Logic
    //------------------------------------------------------------
    always_ff @(posedge clk or posedge rst) begin

        if (rst) begin

            current_state <= IDLE;
            cycle_count   <= '0;
            done          <= 1'b0;

            for (i = 0; i < SIZE; i = i + 1) begin
                row_data[i] <= '0;
                col_data[i] <= '0;
            end

        end
        else begin

            case (current_state)

                //------------------------------------------------
                // IDLE
                //------------------------------------------------
                IDLE: begin

                    done <= 1'b0;

                    if (start) begin
                        current_state <= STREAM;
                        cycle_count   <= '0;
                    end

                end

                //------------------------------------------------
                // STREAM
                //------------------------------------------------
                STREAM: begin

                    for (i = 0; i < SIZE; i = i + 1) begin
                        row_data[i] <= matrix_a[cycle_count][i];
                        col_data[i] <= matrix_b[i][cycle_count];
                    end

                    if (cycle_count == SIZE-1) begin
                        current_state <= DONE;
                    end
                    else begin
                        cycle_count <= cycle_count + 1'b1;
                    end

                end

                //------------------------------------------------
                // DONE
                //------------------------------------------------
                DONE: begin

                    done <= 1'b1;
                    current_state <= IDLE;

                end

                default: begin

                    current_state <= IDLE;
                    done          <= 1'b0;

                end

            endcase

        end

    end

endmodule