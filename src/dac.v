module dac (
    input  wire clk,
    input  wire rst,
    output reg  dac_out
);
    // Mémoire de 512 cases
    reg memory [0:511];

    // Compteur d'adresse
    reg [8:0] rd_addr;

    initial begin
        $readmemb("../src/bitstream.txt", memory, 0, 511);
    end 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_addr <= 9'd0;
            dac_out <= 1'b0;
        end else begin
            dac_out <= memory[rd_addr];
            if (rd_addr == 9'd511)
                rd_addr <= 9'd0;
            else
                rd_addr <= rd_addr + 9'd1;
        end
    end
    
endmodule