`timescale 1ns / 1ps
module tb_top_serial_bcd();
    reg clk = 0;
    reg rst = 1;
    reg btn_press = 0;
    reg is_op1 = 0, is_op2 = 0, is_res = 0;
    reg [15:0] op1 = 16'hFFFF, op2 = 16'h7986, res = 16'h6590;
    wire data, data_enable, busy, done;

    // Instancia del módulo con reset adaptado
    top_serial_bcd dut(
        .clk(clk), .reset(rst), .btn_press(btn_press), .is_op1(is_op1), .is_op2(is_op2), .is_res(is_res),
        .op1(op1), .op2(op2), .res(res), .data(data), .data_enable(data_enable), .busy(busy), .done(done)
    );

        // Inicializamos señales para simulación
    


    // Generador de clock (100MHz simulada)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_top_serial_bcd.vcd");
        $dumpvars(0, tb_top_serial_bcd);

        // Reset inicial
        rst = 1; #20; rst = 0;

        // Prueba op1
        is_op1 = 1; btn_press = 1; #10 btn_press = 0;
        #500;

        // Prueba op2
        is_op1 = 0; is_op2 = 1; btn_press = 1; #10 btn_press = 0;
        #500;

        // Prueba res
        is_op2 = 0; is_res = 1; btn_press = 1; #10 btn_press = 0;
        #500;

        $finish;
    end
endmodule
