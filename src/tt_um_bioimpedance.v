/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_bioimpedance (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

wire TX;
wire RST = ~rst_n;
wire [7:0] MUX_OUT;
wire dac_out;
wire dac_out_ram;
wire qout;

Top_level #(
        .NF (8),
        .NB (8),
        .TOTAL_BITS (128)

    ) u_top(
        .CLK (clk),
        .RST (RST),
        .ADC_IN (ui_in[0]),
        .in (ui_in[5]), //entrée de la bascule
        .TX (TX),
        .MUX_ADDR(ui_in[4:1]),
        .MUX_OUT(MUX_OUT),  
        .dac_out(dac_out),
        .dac_out_ram(dac_out_ram),
        .qout(qout)
    );

  //All output pins must be assigned. If not used, assign to 0.
  assign uio_out[0] = TX;   //Uart transmit
  assign uio_out[1] = clk;  //Clock interne
  assign uio_out[2] = dac_out; 
  assign uio_out[3] = dac_out_ram;
  assign uio_out[4] = qout;   //sortie de la bascuele 
  assign uio_out[7:5] = 3'b0;
  assign uo_out = MUX_OUT;  
  assign uio_oe = 8'b0001_1111; //5 sorties

  // List all unused inputs to prevent warnings
  wire _unused = &{ena,ui_in[7:6],uio_in,1'b0};
 

endmodule
