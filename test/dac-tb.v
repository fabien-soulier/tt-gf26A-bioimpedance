`timescale 1ns/1ps
module tb ();

    // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("dac-tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  //wire up and imputs and outputs
  reg clk;
  reg rst;
  wire dac_out;

  dac dut
  (
    .clk(clk),
    .rst(rst),
    .dac_out(dac_out)
  );


endmodule