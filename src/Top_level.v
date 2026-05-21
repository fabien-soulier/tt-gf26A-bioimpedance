`default_nettype none
`timescale 1ns/1ps

module Top_level #(
    parameter NF = 8,
    parameter NB = 8,
    parameter TOTAL_BITS = 2 * NF * NB  //32 bits
)(
    input  wire CLK,
    input  wire RST,
    input  wire ADC_IN,
    //output wire [TOTAL_BITS-1:0] Q_out,
    output wire TX
);

    wire clk_stage0;  //horloge du premie etage clk/2
    wire clk_stage0_q_unused;  //non utilisé ici car géré par le top module
    
    diviseur2 u_div_start (
        .clk (CLK),
        .rst (RST),
        .clki(clk_stage0),
        .clkq(clk_stage0_q_unused)
    );

    wire [NB-1:0] S [0:NF-1];
    wire [NB-1:0] Q [0:NF-1];
    wire [0:NF-1] clk_chain;  //horloge divisé entrre étages
    
    genvar k;
    generate
        for (k = 0; k < NF; k = k + 1) begin : DEMOD_CHAIN
            //premier étage
            if (k == 0) begin
                top_demod u_demod (
                    .in (ADC_IN),
                    .rst (RST),
                    .clk (clk_stage0), //horloge du premie etage clk/2
                    .i_msb (S[k]),
                    .q_msb (Q[k]),
                    .clk_div2(clk_chain[k])
                );
            end else begin
                //étage suivante
                top_demod u_demod (
                    .in (ADC_IN),
                    .rst (RST),
                    .clk  (clk_chain[k-1]),  //clk_chain[k-1]= clk/2^(k+1)
                    .i_msb  (S[k]),
                    .q_msb  (Q[k]),
                    .clk_div2(clk_chain[k])   // horloge divisée transmise à K+1
                );
            end
        end
    endgenerate

    wire set;
    wire set_q_unused;
    
    diviseur2 u_div_set (
        .clk (clk_chain[NF-1]),
        .rst (RST),
        .clki(set),
        .clkq(set_q_unused)
    );

    wire [TOTAL_BITS-1:0] Q_bus;
    
    assign Q_bus = {
        Q[7], S[7],
        Q[6], S[6],
        Q[5], S[5],
        Q[4], S[4],
        Q[3], S[3],
        Q[2], S[2],
        Q[1], S[1],
        Q[0], S[0]
    };

    wire ready;
    wire [TOTAL_BITS-1: 0]Q_out_interne;

    Output_Register #(
        .NF(NF),
        .NB(NB),
        .TOTAL_BITS(TOTAL_BITS)
    ) u_outreg (
        .clk (CLK),
        .rst (RST),
        .set (set),
        .Q (Q_bus),
        .ready(ready),
        .Q_out(Q_out_interne)
    );

    //MEF de l'UART
    reg [3:0] byte_idx = 0; // 128 bits donc 16 octets à envoyer
    reg sending = 0;
    reg senddata = 0;  //signal déclencheur de l'UART
    reg [7:0] txbyte   = 0;  //octet qu'on va envoyer
    wire txdone;

    uart_tx_8n1 #(
        .CLK_FREQ (1000000),
        .BAUD_RATE (9600)
    )
    uart(
        .clk (CLK),        
        .rst (RST),          
        .txbyte (txbyte),       
        .senddata (senddata),     
        .txdone (txdone), 
        .tx (TX)     
    );

    always @(posedge CLK or posedge RST) begin
        if (RST) begin 
            byte_idx <= 0; 
            sending  <= 0;
            senddata <= 0;  
            txbyte   <= 0;
        end else begin
            senddata <= 0; //enddata = 0 en defaut
    // ready = 1 donc Qout est pres
    if (ready && sending == 0) begin
        sending  <= 1;
        byte_idx <= 0;
    end

    // charger et envoyer l'octet courant
    if (sending == 1 && senddata == 0) begin
        case (byte_idx)
            4'd0:  txbyte <= Q_out_interne[7:0];
            4'd1:  txbyte <= Q_out_interne[15:8];
            4'd2:  txbyte <= Q_out_interne[23:16];
            4'd3:  txbyte <= Q_out_interne[31:24];
            4'd4:  txbyte <= Q_out_interne[39:32];
            4'd5:  txbyte <= Q_out_interne[47:40];
            4'd6:  txbyte <= Q_out_interne[55:48];
            4'd7:  txbyte <= Q_out_interne[63:56];
            4'd8:  txbyte <= Q_out_interne[71:64];
            4'd9:  txbyte <= Q_out_interne[79:72];
            4'd10: txbyte <= Q_out_interne[87:80];
            4'd11: txbyte <= Q_out_interne[95:88];
            4'd12: txbyte <= Q_out_interne[103:96];
            4'd13: txbyte <= Q_out_interne[111:104];
            4'd14: txbyte <= Q_out_interne[119:112];
            4'd15: txbyte <= Q_out_interne[127:120];
endcase
        senddata <= 1;
    end

    // octet envoyer passer au suivant ou terminer
    if (txdone == 1) begin
        senddata <= 0;
        if (byte_idx < 4'd15) begin
            byte_idx <= byte_idx + 1;  // octet suivant
        end else begin
            sending  <= 0;             
            byte_idx <= 0;
        end

            end

        end
    end


endmodule