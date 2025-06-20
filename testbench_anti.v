`timescale 1ns / 1ps

module tb_keyb_antibounce;

    reg clk;
    reg reset;
    reg btn_press_in;
    wire enable;

    keyb_antibounce uut (
        .clk(clk),
        .reset(reset),
        .btn_press_in(btn_press_in),
        .enable(enable)
    );

    localparam CLK_PERIOD = 20;

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        reset = 1;
        btn_press_in = 0;
        #(CLK_PERIOD * 10);
        reset = 0;

        // Rebote 1
        #(CLK_PERIOD * 5);
        btn_press_in = 1;
        #(CLK_PERIOD * 2);
        btn_press_in = 0;
        #(CLK_PERIOD * 3);
        btn_press_in = 1;
        #(CLK_PERIOD * 1);
        btn_press_in = 0;
        #(CLK_PERIOD * 4);
        btn_press_in = 1;
        #(CLK_PERIOD * 2);
        btn_press_in = 0;
        #(CLK_PERIOD * 3);
        btn_press_in = 1;

        #(CLK_PERIOD * 60000);  // espera debounce

        btn_press_in = 0;

        // Rebote 2, más tarde en el tiempo
        #(CLK_PERIOD * 10000);
        btn_press_in = 1;
        #(CLK_PERIOD * 3);
        btn_press_in = 0;
        #(CLK_PERIOD * 5);
        btn_press_in = 1;
        #(CLK_PERIOD * 2);
        btn_press_in = 0;
        #(CLK_PERIOD * 4);
        btn_press_in = 1;

        #(CLK_PERIOD * 60000);

        btn_press_in = 0;

        // Rebote 3, más tarde otra vez
        #(CLK_PERIOD * 15000);
        btn_press_in = 1;
        #(CLK_PERIOD * 1);
        btn_press_in = 0;
        #(CLK_PERIOD * 2);
        btn_press_in = 1;
        #(CLK_PERIOD * 3);
        btn_press_in = 0;
        #(CLK_PERIOD * 1);
        btn_press_in = 1;

        #(CLK_PERIOD * 60000);

        btn_press_in = 0;

        #(CLK_PERIOD * 1000);

        $finish;
    end


    initial begin
        $dumpfile("keyb_antibounce_tb.vcd");   // <-- Acá
        $dumpvars(0, tb_keyb_antibounce);       // <-- Acá
    end

endmodule
