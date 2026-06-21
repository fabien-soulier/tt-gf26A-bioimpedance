module uart_tx_8n1 #(
    parameter CLK_FREQ  = 1000000,  // frequence d'horloge
    parameter BAUD_RATE = 9600      
)
(
    input  wire       clk,          // input clock
    input  wire       rst,          // reset
    input  wire [7:0] txbyte,       // outgoing byte
    input  wire       senddata,     // trigger tx
    output reg        txdone,       // outgoing byte sent
    output wire       tx            // tx wire
);

    // nombre de cycles par bit
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;  

    /* Parameters */
    parameter STATE_IDLE    = 8'd0;
    parameter STATE_STARTTX = 8'd1;
    parameter STATE_TXING   = 8'd2;
    parameter STATE_TXDONE  = 8'd3;
    parameter STATE_TXEND   = 8'd4;

   /* State variables */
    reg [7:0]  state     = 8'b0;
    reg [7:0]  buf_tx    = 8'b0;
    reg [7:0]  bits_sent = 8'b0;
    reg [15:0] clk_count = 16'b0;  //compteur baudrate
    reg        txbit     = 1'b1;

    assign tx = txbit;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= STATE_IDLE;
            txbit     <= 1'b1;
            txdone    <= 1'b0;
            clk_count <= 0;
            bits_sent <= 0;
        end else begin
         //start sending? wait senddata
            if (senddata == 1 && state == STATE_IDLE) begin
                state  <= STATE_STARTTX;
                buf_tx <= txbyte;  //On copiel'octet 
                txdone <= 1'b0;
            end else if (state == STATE_IDLE) begin
                // idle at high
                txbit  <= 1'b1;    
                txdone <= 1'b0;
            end

            //send bit start
            if (state == STATE_STARTTX) begin
                txbit <= 1'b0;
                if (clk_count < CLKS_PER_BIT - 1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    bits_sent <= 0;
                    state     <= STATE_TXING;
                end
            end

            // send 8 bits
            if (state == STATE_TXING && bits_sent < 8'd8) begin
                txbit <= buf_tx[0]; //lsb en premier
                if (clk_count < CLKS_PER_BIT - 1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    buf_tx    <= buf_tx>>1;  //décale au bit suivant
                    bits_sent <= bits_sent + 1;
                end
            end else if (state == STATE_TXING) begin
                txbit     <= 1'b1;
                bits_sent <= 8'b0;
                clk_count <= 0;
                state     <= STATE_TXDONE;   
            end

            //envoyer bit de stop
            if (state == STATE_TXDONE) begin
                txbit <= 1'b1;
                if (clk_count < CLKS_PER_BIT - 1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    txdone    <= 1'b1;  
                    state     <= STATE_TXEND;
                end
            end

            if (state == STATE_TXEND) begin
                txdone <= 1'b1;  
                if (senddata == 0) begin   
                    txdone <= 1'b0;
                    state  <= STATE_IDLE;
                end
            end
        end
    end

endmodule