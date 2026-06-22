module Output_Register #(
    parameter NF = 8, 
    parameter NB = 8, 
    parameter TOTAL_BITS = NF*NB*2
)(
   
    input  wire rst,
    input  wire set,
    input  wire sending,
    input  wire clk,                     
    output reg  ready,
    input  wire [TOTAL_BITS-1:0] Q,
    output reg  [TOTAL_BITS-1:0] Q_out
);

always @(posedge set or posedge rst) begin
    if (rst) begin
        Q_out <= {TOTAL_BITS{1'b0}};
        ready <= 1'b0;
    end 
    else begin
        //ready <= 1'b0;
        if (set && !sending) begin
            Q_out <= Q;
            ready <= 1'b1;
        end 
        else ready <= 1'b0;
        end
    end
endmodule
