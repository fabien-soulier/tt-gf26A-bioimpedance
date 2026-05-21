`timescale 1ns/1ps

module Output_Register #(
    parameter NF = 8,
    parameter NB = 8,
    parameter TOTAL_BITS = NF * NB * 2
)(
    input wire clk,
    input wire rst,
    input wire set,
    output reg ready,
    input wire [TOTAL_BITS-1:0] Q,
    output reg [TOTAL_BITS-1:0] Q_out
);

    always @(posedge clk) begin
    ready <= 0;
    if (rst) begin
        Q_out <= {TOTAL_BITS{1'b0}};
    end else if (set) begin
        Q_out <= Q;
        ready <= 1;
    end
end

endmodule
