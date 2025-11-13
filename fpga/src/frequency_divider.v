module frequency_divider(
    input wire clk, // Input clock  
    input wire rst, // Asynchronous reset
    output reg  clk2i,  // Output clock (in-phase)
    output reg  clk2q   // Output clock (quadrature)
);

    always @(rst) begin
        clk2i <= 0;
        clk2q <= 0;
    end
   
    always @(posedge clk) begin
        clk2i <= ~clk2i;
    end

    always @(negedge clk) begin
        clk2q <= ~clk2q;
    end

endmodule
