`timescale 1ns / 1ps

module bin_to_bcd_tb;

    // Entradas
    reg [15:0] num_bin;

    // Salidas
    wire [15:0] num_BCD;

    // Instancia del módulo bajo prueba
    bin_to_bcd_double_dabble uut (
        .num_bin(num_bin),
        .num_BCD(num_BCD)
    );

    initial begin
        // Para GTKWave
        $dumpfile("bin_to_bcd_tb.vcd");
        $dumpvars(0, bin_to_bcd_tb);

        $display("Tiempo | num_bin (DEC) | num_BCD (HEX)");
        $monitor("%4t    |     %0d       |     %h", $time, num_bin, num_BCD);

        num_bin = 0;      #10;
        num_bin = 5;      #10;
        num_bin = 9;      #10;
        num_bin = 10;     #10;
        num_bin = 123;    #10;
        num_bin = 255;    #10;
        num_bin = 999;    #10;
        num_bin = 1234;   #10;
        num_bin = 9999;   #10;

        #10;
        $finish;
    end

endmodule
