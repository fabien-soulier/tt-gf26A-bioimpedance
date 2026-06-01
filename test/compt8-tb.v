module tb();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("compt8-tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clki = 0;
  reg clkq = 0;
  reg inp = 0;  
  reg rst = 0;
  wire [7:0] count_I;
  wire [7:0] count_Q;

  compt8 dut(
      .clki(clki),
      .clkq(clkq),
      .inp(inp),  
      .rst(rst),
      .count_I(count_I),
      .count_Q(count_Q)
  );

endmodule