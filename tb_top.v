`timescale 1ns/1ps

module tb_top;

    reg clk = 0;
    reg rst_n = 0;
    reg is_num = 0;
    reg is_op1 = 0;
    reg is_op2 = 0;
    reg [3:0] num_val = 0;
    reg [3:0] op_val = 4'b1101;  // Por defecto suma
    reg save = 0;

    wire [15:0] op1_bin;
    wire [15:0] op2_bin;
    wire [15:0] alu_result_bcd;
    wire f_OF;
    wire f_sig_res;

    // Reloj 10ns período
    always #5 clk = ~clk;

    top uut (
        .clk(clk),
        .rst_n(rst_n),
        .is_num(is_num),
        .is_op1(is_op1),
        .is_op2(is_op2),
        .num_val(num_val),
        .op_val(op_val),
        .save(save),
        .op1_bin(op1_bin),
        .op2_bin(op2_bin),
        .alu_result_bcd(alu_result_bcd),
        .f_OF(f_OF),
        .f_sig_res(f_sig_res)
    );

    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);

        // Reset inicial
        rst_n = 0;
        #20;
        rst_n = 1;

        // Cargar op1 = 1,2,3,4
        is_op1 = 1; is_op2 = 0;
        is_num = 1;
        num_val = 4'd1; #10;
        num_val = 4'd2; #10;
        num_val = 4'd3; #10;
        num_val = 4'd4; #10;
        is_num = 0;

        // Cargar op2 = 5,6,7,8
        is_op1 = 0; is_op2 = 1;
        is_num = 1;
        num_val = 4'd5; #10;
        num_val = 4'd6; #10;
        num_val = 4'd7; #10;
        num_val = 4'd8; #10;
        is_num = 0;

        // Cambiar op_val a resta
        op_val = 4'b1110;

        // Guardar resultado (activar save)
        save = 1; #10;
        save = 0;

        // Cargar op1 nuevo: 5,6,7,8
        is_op1 = 1; is_op2 = 0;
        is_num = 1;
        num_val = 4'd5; #10;
        num_val = 4'd6; #10;
        num_val = 4'd7; #10;
        num_val = 4'd8; #10;
        is_num = 0;

        #50;

        $finish;
    end

    // Monitor para ver los valores en consola
    initial begin
        $monitor("Time=%0t | op1_bin=%0d | op2_bin=%0d | alu_result_bcd=%h | f_OF=%b | f_sig_res=%b",
                  $time, op1_bin, op2_bin, alu_result_bcd, f_OF, f_sig_res);
    end

endmodule
