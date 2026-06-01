`timescale 1ns/1ps

module compt256 (
    input  wire clk,        
    input  wire rst,        
    output reg  set //impulsion set tous les 256 cycles
);

    reg [7:0] cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 8'd0;
            set <= 1'b0;
        end else if (cnt == 8'd255) begin
            cnt <= 8'd0;
            set <= 1'b1;
        end else begin
            cnt <= cnt +8'd1;
            set <= 1'b0;
        end
    end

endmodule