module top(
    input clk,
    input rst_n,
    input is_num,
    input is_op1,
    input is_op2,
    input [3:0] num_val,
    input [3:0] op_val,
    input save,

    output [15:0] op1_bin,
    output [15:0] op2_bin,
    output [15:0] alu_result_bcd,
    output f_OF,
    output f_sig_res
);

    // Dígitos operandos BCD
    wire [3:0] op1_d0, op1_d1, op1_d2, op1_d3;
    wire [3:0] op2_d0, op2_d1, op2_d2, op2_d3;

    wire [15:0] op1_bcd = {op1_d3, op1_d2, op1_d1, op1_d0};
    wire [15:0] op2_bcd = {op2_d3, op2_d2, op2_d1, op2_d0};

    // Conversión BCD a binario 14 bits
    wire [13:0] op1_bin_14;
    wire [13:0] op2_bin_14;

    BCD_bn conv_op1 (
        .num_BCD(op1_bcd),
        .num_bin(op1_bin_14)
    );

    BCD_bn conv_op2 (
        .num_BCD(op2_bcd),
        .num_bin(op2_bin_14)
    );

    // ALU Core con suma y resta
    wire [13:0] res_suma_bin, res_resta_bin;
    wire f_OF_alu, f_sig_res_alu;

    alu_core alu_inst(
        .op1(op1_bin_14),
        .op2(op2_bin_14),
        .op_val(op_val),
        .res_suma(res_suma_bin),
        .res_resta(res_resta_bin),
        .f_OF(f_OF_alu),
        .f_sig_res(f_sig_res_alu)
    );

    // Mux y conversor BCD
    wire [15:0] res_bcd;
    wire [3:0] res_d3, res_d2, res_d1, res_d0;

    mux_and_bcd_converter mux_bcd_inst(
        .res_suma_bin(res_suma_bin),
        .res_resta_bin(res_resta_bin),
        .operator(op_val == 4'b1101), // suma
        .is_res(save),
        .result_bcd(res_bcd),
        .res_d3(res_d3),
        .res_d2(res_d2),
        .res_d1(res_d1),
        .res_d0(res_d0)
    );

    // FSM memory para almacenamiento
    fsm_memory mem_inst(
        .clk(clk),
        .rst_n(rst_n),
        .is_num(is_num),
        .is_op1(is_op1),
        .is_op2(is_op2),
        .save(save),
        .num_val(num_val),
        .res_d0(res_d0),
        .res_d1(res_d1),
        .res_d2(res_d2),
        .res_d3(res_d3),
        .cnt(),
        .block(),
        .op1_d0(op1_d0),
        .op1_d1(op1_d1),
        .op1_d2(op1_d2),
        .op1_d3(op1_d3),
        .op2_d0(op2_d0),
        .op2_d1(op2_d1),
        .op2_d2(op2_d2),
        .op2_d3(op2_d3)
    );

    // Salidas para testbench o debug
    assign op1_bin = {2'b00, op1_bin_14};
    assign op2_bin = {2'b00, op2_bin_14};
    assign alu_result_bcd = res_bcd;
    assign f_OF = f_OF_alu;
    assign f_sig_res = f_sig_res_alu;

endmodule
