module bascule (
    input wire clk,
    input wire rst,
    input wire in,
    output reg qout  //le mettre sur un des pins de sortie libre
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            qout <= 0;
        else
            qout <= in;
    end 
    
endmodule