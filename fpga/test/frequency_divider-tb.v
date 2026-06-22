module tb();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("frequency_divider-tb.fst");
    $dumpvars(1, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk = 0;
  reg rst = 0;
  wire clki;
  wire clkq;

  frequency_divider fd(
      .clk(clk),
      .rst(rst),
      .clki(clki),
      .clkq(clkq)
  );

endmodule
