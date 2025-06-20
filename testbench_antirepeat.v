`timescale 1ns/1ps

module tb_keyb_antirepeat();

    reg clk;
    reg reset;
    reg enable_filter;
    wire enable_real;

    // Instancia del módulo bajo prueba (DUT)
    keyb_antirepeat dut (
        .clk(clk),
        .reset(reset),
        .enable_filter(enable_filter),
        .enable_real(enable_real)
    );

    // Generador de clock: 10 ns de período (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Configuración para generar el archivo .vcd
        $dumpfile("keyb_antirepeat.vcd");  // Nombre del archivo VCD
        $dumpvars(0, tb_keyb_antirepeat);  // Volcar todas las señales de este módulo y submódulos

        // Monitor en consola (opcional)
        $display("Tiempo\tclk\treset\ten_filter\ten_real");
        $monitor("%0dns\t%b\t%b\t%b\t\t%b", $time, clk, reset, enable_filter, enable_real);

        // Inicialización
        reset = 1;
        enable_filter = 0;

        // Tiempo de reset
        #15;
        reset = 0;

        // Esperar un poco en estado inicial
        #20;

        // Flanco ascendente
        enable_filter = 1;
        #20;

        // Mantener en alto
        #40;

        // Flanco descendente
        enable_filter = 0;
        #20;

        // Segundo flanco ascendente
        enable_filter = 1;
        #20;

        // Fin de simulación
        #20;
        $finish;
    end

endmodule
