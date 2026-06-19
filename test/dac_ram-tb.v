module tb ();

    // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("dac_ram-tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  //wire up and imputs and outputs
  reg clk;
  reg rst;
  wire dac_out_ram;
  reg dac_data_in;
  reg  we;

  dac_ram dut
  (
    .clk(clk),
    .rst(rst),
    .dac_out_ram(dac_out_ram),
    .we(we),
    .dac_data_in(dac_data_in)
  );


endmodule