module frequency_divider(
    input wire clk, // Input clock  
    input wire rst, // Asynchronous reset
    output reg  clki,  // Output clock (in-phase)
    output reg  clkq   // Output clock (quadrature)
);

    reg clki_started; // Ensure clki starts first.
    
    always @(clk or posedge rst) begin
        if (rst) begin
            clki <= 0;
            clkq <= 0;
            clki_started <= 0;
        end 
        else if (clk) begin
            clki <= ~clki;
	    clki_started <= 1;
	end
        else if (~clk && clki_started) clkq <= ~clkq;
    end

endmodule
