module tb;
    reg clk = 0;
    reg rst = 1;
    wire clk2i;
    wire clk2q;

    frequency_divider fd(
        .clk(clk),
        .rst(rst),
        .clk2i(clk2i),
        .clk2q(clk2q)
    );

    always #1 clk = ~clk;

    initial begin
        $dumpfile("frequency_divider-tb.vcd");
        $dumpvars(1, tb);
        #2 rst = 0;
        #10 $finish;
    end
endmodule
