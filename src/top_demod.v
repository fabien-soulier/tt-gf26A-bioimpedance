module top_demod #(
    parameter NB = 8,                       
    parameter NF = 8,
    parameter J  = 0 //indice de l'étage       
)(
    input  wire in,
    input  wire rst,
    input  wire clk,
    input  wire master_clk,
    input  wire RZ,
    output wire [7:0] i_msb,
    output wire [7:0] q_msb,
    output wire clk_div2
);

wire clki, clkq;
wire [7:0] count_I, count_Q;
wire rst_cnt ;
assign rst_cnt = rst || RZ ;

diviseur2 u_div (
    .clk (clk),
    .rst (rst),
    .clki(clki),
    .clkq(clkq)
);

assign clk_div2 = clki;

compt8 #(
    .NB (NB),
    .NF (NF),
    .J (J)
) u_cnt (
    .clki (clki),
    .clkq (clkq),
    .inp (in),
    .rst (rst_cnt),
    .count_I (count_I),
    .count_Q (count_Q),
    .master_clk(master_clk)
);

assign i_msb = count_I;
assign q_msb = count_Q;

endmodule