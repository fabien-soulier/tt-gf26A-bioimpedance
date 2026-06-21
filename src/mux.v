module mux (
    input wire [127:0] data_in,//128 bits 16 octets
    input wire [3:0] addr, //entrée de selection
    output reg [7:0] data_out
);

always @(*) begin
    case (addr)
        4'd0:  data_out = data_in[7:0];
        4'd1:  data_out = data_in[15:8];
        4'd2:  data_out = data_in[23:16];
        4'd3:  data_out = data_in[31:24];
        4'd4:  data_out = data_in[39:32];
        4'd5:  data_out = data_in[47:40];
        4'd6:  data_out = data_in[55:48];
        4'd7:  data_out = data_in[63:56];
        4'd8:  data_out = data_in[71:64];
        4'd9:  data_out = data_in[79:72];
        4'd10: data_out = data_in[87:80];
        4'd11: data_out = data_in[95:88];
        4'd12: data_out = data_in[103:96];
        4'd13: data_out = data_in[111:104];
        4'd14: data_out = data_in[119:112];
        4'd15: data_out = data_in[127:120];
        default: data_out = 8'd0;
    endcase
end

endmodule