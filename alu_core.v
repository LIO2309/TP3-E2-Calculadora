module alu_core (
    input wire [13:0] op1,
    input wire [13:0] op2,
    input wire [3:0] op_val,   // 1101 suma, 1110 resta

    output reg [13:0] res_suma,
    output reg [13:0] res_resta,
    output reg f_OF,
    output reg f_sig_res
);

    // Constante decimal 9999 en binario 14 bits
    localparam MAX_DECIMAL = 14'd9999;

    wire [14:0] sum_ext = {1'b0, op1} + {1'b0, op2};  // 15 bits para posible overflow
    wire [14:0] sub_ext = {1'b0, op1} - {1'b0, op2};

    always @(*) begin
        f_OF = 0;
        f_sig_res = 0;
        res_suma = 14'd0;
        res_resta = 14'd0;

        // Suma con overflow si > 9999
        if (sum_ext > MAX_DECIMAL) begin
            f_OF = 1;
            res_suma = 14'd0;
        end else begin
            res_suma = sum_ext[13:0];
        end

        // Resta con flag de resultado negativo
        if (sub_ext[14] == 1'b1) begin
            f_sig_res = 1;
            res_resta = 14'd0;
        end else begin
            res_resta = sub_ext[13:0];
        end
    end

endmodule
