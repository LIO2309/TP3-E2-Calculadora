module top_alu_system(
    input clk,
    input rst_n,
    input is_num,
    input is_op1,
    input is_op2,
    input [3:0] num_val,
    input [3:0] op_val,        // Control de operación para ALU (1101 suma, 1110 resta)
    output [15:0] result_bcd
);

    // Señales entre módulos
    wire [3:0] op1_d0, op1_d1, op1_d2, op1_d3;
    wire [3:0] op2_d0, op2_d1, op2_d2, op2_d3;
    wire [1:0] cnt;
    wire block;

    // Instancia memoria operandos
    dual_operand_digits mem_oper (
        .clk(clk),
        .rst_n(rst_n),
        .is_num(is_num),
        .is_op1(is_op1),
        .is_op2(is_op2),
        .num_val(num_val),
        .cnt(cnt),
        .block(block),
        .op1_d0(op1_d0), .op1_d1(op1_d1), .op1_d2(op1_d2), .op1_d3(op1_d3),
        .op2_d0(op2_d0), .op2_d1(op2_d1), .op2_d2(op2_d2), .op2_d3(op2_d3)
    );

    // Armar los operandos en formato BCD de 16 bits (nibble 3 MSB)
    wire [15:0] oper1_bcd = {op1_d3, op1_d2, op1_d1, op1_d0};
    wire [15:0] oper2_bcd = {op2_d3, op2_d2, op2_d1, op2_d0};

    // Instancia ALU
    alu_bcd alu (
        .clk(clk),
        .rst(~rst_n),   // En alu_bcd el reset es activo alto, acá es activo bajo
        .oper1_bcd(oper1_bcd),
        .oper2_bcd(oper2_bcd),
        .op_val(op_val),
        .result_bcd(result_bcd)
    );

endmodule
