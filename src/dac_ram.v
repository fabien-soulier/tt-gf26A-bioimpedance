module dac_ram(
    input wire clk,
    input wire dac_data_in,
    input wire rst,
    input wire we, 
    output reg  dac_out_ram
);

    // Mémoire de 512 cases
    reg memory [0:511];

    reg [8:0] rd_addr; //registre de lecture
    reg [8:0] wr_addr; // registre d'ecriture

    //initialisation de la RAM
    initial begin
        $readmemb("../src/bitstream.txt", memory, 0, 511);
    end

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            rd_addr <= 9'd0;
            wr_addr <= 9'd0;
            dac_out_ram <= 1'd0;
        end else begin
            if (we) begin
                memory[wr_addr] <= dac_data_in; //écriture
                //dac_out_ram <= dac_data_in; //write first
                wr_addr <= wr_addr + 9'd1;
            end else begin
                dac_out_ram <= memory[rd_addr]; //lecture
                rd_addr <= rd_addr + 9'd1;
            end
            
            

        end

    end

endmodule
