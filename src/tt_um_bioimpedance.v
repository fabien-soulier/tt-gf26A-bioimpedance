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

Top_level #(
        .NF (8),
        .NB (8),
        .TOTAL_BITS (128)
    ) u_top(
        .CLK (ui_in[1]),
        .RST (RST),
        .ADC_IN (ui_in[0]),
        .TX (TX)
    );

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[0] = TX;
  assign uo_out[7:1] = 7'b0;
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ui_in[7:2], uio_in, 1'b0};

endmodule
