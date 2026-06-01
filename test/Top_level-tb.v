`timescale 1ns/1ps

module tb;
    parameter NF = 8;
    parameter NB = 8;
    parameter TOTAL_BITS = 2 * NF * NB;
    
    reg CLK;
    reg RST;
    reg ADC_IN;
    reg MUX_ADDR = 0; 
    
    //wire [TOTAL_BITS-1:0] Q_out;
    wire TX;
    wire [7:0] MUX_OUT;

    
    Top_level #(
        .NF(NF),
        .NB(NB),
        .TOTAL_BITS(TOTAL_BITS)
    )dut (
        .CLK(CLK),
        .RST(RST),
        .ADC_IN(ADC_IN),
        //.Q_out(Q_out)
        .TX (TX),
        .MUX_ADDR(MUX_ADDR),
        .MUX_OUT(MUX_OUT)
    );

    wire ready;
    assign ready = dut.u_outreg.ready;

endmodule