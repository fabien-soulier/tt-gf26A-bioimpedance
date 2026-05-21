`timescale 1ns/1ps

module top_demod (
    input  wire in,
    input  wire rst,
    input  wire clk,
    output wire [7:0] i_msb,
    output wire [7:0] q_msb,
    output wire clk_div2
);
    wire clki, clkq;
    wire [7:0] count_I, count_Q;
    
    diviseur2 u_div (
        .clk (clk),
        .rst (rst),
        .clki(clki),
        .clkq(clkq)
    );
    
    assign clk_div2 = clki;
    
    compt8 u_cnt (
        .clki    (clki),
        .clkq    (clkq),
        .inp     (in),
        .rst     (rst),
        .count_I (count_I),
        .count_Q (count_Q)
    );
    
    assign i_msb = count_I;  // ils sont 
    assign q_msb = count_Q;
    
endmodule