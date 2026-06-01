`timescale 1ns/1ps

module tb();
    parameter NF = 8;
    parameter NB = 8;
    parameter TOTAL_BITS = 2 * NF * NB;

    reg rst = 0;
    reg set = 0;
    reg sending = 0;
    wire ready;
    reg  [TOTAL_BITS-1:0] Q = 0;
    wire [TOTAL_BITS-1:0] Q_out;

    Output_Register #(
        .NF(NF),
        .NB(NB),
        .TOTAL_BITS(TOTAL_BITS)
    ) DUT (
        .rst     (rst),
        .set     (set),
        .sending (sending),
        .ready   (ready),
        .Q       (Q),
        .Q_out   (Q_out)
    );

    initial begin
        $dumpfile("Output_Register-tb.fst");
        $dumpvars(0, tb);
    end

endmodule