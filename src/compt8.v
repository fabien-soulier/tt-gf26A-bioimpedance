`timescale 1ns/1ps
module compt8 (
    input  wire clki,   
    input  wire clkq, 
    input wire inp,  // signal reçu en binaire
    input wire rst,  
    output reg  [7:0] count_I = 8'd0, // compteur in-phase
    output reg  [7:0] count_Q = 8'd0  // compteur Quadrature
);
    // voie I
    always @(posedge clki) begin
        if (rst)
            count_I <= 8'b0;       // amodifier
        else if (inp)
            count_I <= count_I + 1'b1;   // compte quand entree = 1
            // sinon bloqué 
    end
    // voie Q
    always @(posedge clkq) begin
        if (rst)
            count_Q <= 8'b0;       
        else if (inp)
            count_Q <= count_Q + 1'b1;   // compte quand entree = 1 
    end
endmodule