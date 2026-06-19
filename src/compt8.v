module compt8 #(
    parameter NB = 8,                       
    parameter NF = 8,
    parameter J  = 0 //indice de l'étage                    
)(
    input  wire clki,
    input  wire clkq,
    input  wire inp, // signal recu en binaire
    input  wire rst,
    output wire [NB-1:0] count_I, //8 bits voie in-phase
    output wire [NB-1:0] count_Q,//8 bits voie quadrature
    input wire master_clk
);

    //nb+nf-j-1 
    localparam ACC_W = NB + NF - J - 1;

    //décalage nf-j-1
    localparam SHIFT = NF - J - 1;

    reg [ACC_W-1:0] acc_I = 0;
    reg [ACC_W-1:0] acc_Q = 0;
    reg [NB -1 :0] enI =  0 ;
    reg [NB -1 :0] enQ =  0 ;

    always @ (posedge clki) begin
        enI <= {NB{1'b1}}; 
    end

    always @ (posedge clkq) begin
         enQ <= {NB{1'b1}};
    end

    // voie I
    always @(posedge master_clk or posedge rst ) begin
        if (rst) begin
        acc_I <= 0;
        enI <= 0;
    end else if (inp && (enI !== 0))

            acc_I <= acc_I + 1'b1;
    end

    always @(posedge master_clk) begin
        if (enI !==0)
         enI <= enI - 1'b1;
    end
    

    // voie Q
    always @(posedge master_clk or posedge rst) begin
        if (rst) begin
        acc_Q <= 0;
        enQ <= 0;
    end
        else if  (inp && (enQ !== 0))
            acc_Q <= acc_Q + 1'b1;
    end
    always @(posedge master_clk) begin

        if (enQ !==0)

         enQ <= enQ - 1'b1;
    end

    // Fenetre de NB bits
    assign count_I = acc_I[SHIFT + NB - 1 : SHIFT];
    assign count_Q = acc_Q[SHIFT + NB - 1 : SHIFT];

endmodule
