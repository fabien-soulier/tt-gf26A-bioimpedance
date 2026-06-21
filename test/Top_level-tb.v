module tb();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("Top_level-tb.fst");
    $dumpvars(0, tb);
    #1;
  end
    parameter NF = 8;
    parameter NB = 8;
    parameter TOTAL_BITS = 2 * NF * NB;
    
    reg CLK;
    reg RST;
    reg ADC_IN;
    reg [3:0] MUX_ADDR = 0;
    reg in;
    
    //wire [TOTAL_BITS-1:0] Q_out;
    wire TX;
    wire [7:0] MUX_OUT;
    wire dac_out;
    wire dac_out_ram;
    wire qout;
    
    Top_level #(
        .NF(NF),
        .NB(NB),
        .TOTAL_BITS(TOTAL_BITS)
    )dut(
        .CLK(CLK),
        .RST(RST),
        .ADC_IN(ADC_IN),
        //.Q_out(Q_out)
        .TX (TX),
        .MUX_ADDR(MUX_ADDR),
        .MUX_OUT(MUX_OUT),
        .dac_out(dac_out),
        .dac_out_ram(dac_out_ram),
        .qout(qout),
        .in(in)
    );

    wire ready;
    assign ready = dut.u_outreg.ready;
    


endmodule