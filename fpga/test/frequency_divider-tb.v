module tb;
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

    always #1 clk = ~clk;

//    sequence freq;
//       (clki == 0) ##2 (clki == 0);
//    endsequence
//   
    initial begin
        $dumpfile("frequency_divider-tb.vcd");
        $dumpvars(1, tb);
        #1 rst = 1;
        #1 assert(clki == 0 && clkq == 0) 
          else $error("Asynchronous reset failed.");
        #2 rst = 0;       
       // #1 (clki == 1 && clkq == 0)
        #12 $finish;
    end

endmodule


