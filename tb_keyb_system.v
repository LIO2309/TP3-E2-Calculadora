`timescale 1ns / 1ps

module tb_keyb_system;

    // Entradas principales
    reg clk;
    reg reset;
    reg [3:0] row;
    reg [3:0] col;

    // Conexiones internas
    wire [3:0] btn_out;          // Desde controller hacia decoder
    wire btn_pressed;            // Desde controller hacia antibounce
    wire enable;                 // Desde antibounce hacia antirepeat
    wire [3:0] btn_id;           // Desde decoder hacia antirepeat
    wire [3:0] btn_id_filtered;  // Salida final
    wire new_event;              // Salida final

    // Generación de clock
    always #5 clk = ~clk; // Clock de 100MHz

    // -----------------------
    // Instanciación de módulos
    // -----------------------

    keyb_controller controller (
        .clk(clk),
        .reset(reset),
        .row(row),
        .col(col),
        .btn_out(btn_out),
        .btn_pressed(btn_pressed)
    );

    keyb_antibounce antibounce (
        .clk(clk),
        .reset(reset),
        .btn_press_in(btn_pressed),
        .enable(enable)
    );

    keyb_decoder decoder (
        .btn_id(btn_out),
        .btn_ascii(btn_id) // Asegurate de que este puerto se llame así en tu módulo
    );

    keyb_antirepeat antirepeat (
        .clk(clk),
        .reset(reset),
        .enable_filter(enable),
        .btn_code(btn_id),
        .new_event(new_event),
        .btn_out(btn_id_filtered)
    );

    // -----------------------
    // Estímulos
    // -----------------------

    initial begin
        $dumpfile("tb_keyb_system.vcd");
        $dumpvars(0, tb_keyb_system);

        clk = 0;
        reset = 1;
        row = 4'b1111;
        col = 4'b0000;

        #20;
        reset = 0;

        // Simular una tecla con rebotes
        #100;
        simulate_keypress(4'b1110, 4'b0111); // Tecla presionada (fila 0, columna 3)

        #1000;
        $finish;
    end

    // Tarea para simular rebotes de tecla
    task simulate_keypress(input [3:0] row_val, input [3:0] col_val);
        begin
            repeat (5) begin
                row = row_val; col = col_val; #20;
                row = 4'b1111; col = 4'b0000; #20;
            end
            row = row_val; col = col_val; #200;
            row = 4'b1111; col = 4'b0000; #20;
        end
    endtask

endmodule
