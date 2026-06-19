module div256 (
    input  wire clk,
    input  wire rst,
    output wire clk_256
);
reg [7:0] cnt_div256 = 0;
assign clk_256 = cnt_div256[7];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt_div256 <= 0;
    end else begin
        cnt_div256 <= cnt_div256 + 1;
    end
end

endmodule