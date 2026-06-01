`timescale 1ns/1ps

module tb();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("compt8-tb.fst");
    $dumpvars(1, tb);
    #1;
  end
    // input and output
    reg in;
    reg rst;
    reg clk;
    wire [7:0] i_msb;
    wire [7:0] q_msb;
    wire clk_div2;

    top_demod dut (
        .in(in),
        .rst(rst),
        .clk(clk),
        .i_msb(i_msb),
        .q_msb(q_msb),
        .clk_div2(clk_div2)
    );

endmodule
