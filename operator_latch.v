module operator_latch (
    input wire clk,
    input wire rst_n,
    input wire [1:0] op_val,   // 01: suma, 10: resta
    output reg operator        // 1: suma activa, 0: resta activa
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            operator <= 1'b0;
        end else begin
            case (op_val)
                2'b01: operator <= 1'b1;  // "+" presionado
                2'b10: operator <= 1'b0;  // "-" presionado
                default: operator <= operator;  // Mantiene estado
            endcase
        end
    end

endmodule
