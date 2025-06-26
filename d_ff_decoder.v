module d_ff_decoder (
    input wire clk,
    input wire reset,
    input wire en,

    // Entradas sin registrar
    input wire is_num_in,
    input wire is_op_in,
    input wire is_eq_in,
    input wire [3:0] num_val_in,
    input wire [1:0] op_val_in,
    input wire clear_in,
    input wire btn_pressed_in,

    // Salidas registradas
    output reg is_num,
    output reg is_op,
    output reg is_eq,
    output reg [3:0] num_val,
    output reg [1:0] op_val,
    output reg clear,
    output reg btn_pressed
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            is_num       <= 0;
            is_op        <= 0;
            is_eq        <= 0;
            num_val      <= 4'b0000;
            op_val       <= 2'b00;
            clear        <= 0;
            btn_pressed  <= 0;
        end else if (en) begin
            is_num       <= is_num_in;
            is_op        <= is_op_in;
            is_eq        <= is_eq_in;
            num_val      <= num_val_in;
            op_val       <= op_val_in;
            clear        <= clear_in;
            btn_pressed  <= btn_pressed_in;
        end
    end

endmodule