//_________________________________________________________
//                                                         |
//               CONTROLADOR RGB Y BUZZER                  |
//_________________________________________________________|
//                                                         |
// Descripción: Módulo superior que controla un LED RGB y  |
// un buzzer. El LED indica el estado del sistema según    |
// prioridades, incluyendo errores latcheados. Los errores |
// se mantienen activos hasta que el usuario presiona un   |
// botón, lo que también activa el buzzer brevemente.      |
//_________________________________________________________|
//                                                         |
// *Entradas:                                              |
// - clk: Señal de reloj                                   |
// - reset: Reset síncrono                                 |
// - btn_press: Pulso que indica interacción del usuario   |
// - f_sig_res: Pulso (1 ciclo) indicando error de signo   |
// - overflow: Pulso (1 ciclo) indicando desbordamiento    |
// - is_op1: Señal activa al mostrar operando 1            |
// - is_op2: Señal activa al mostrar operando 2            |
// - is_res: Señal activa al mostrar el resultado          |
//_________________________________________________________|
//                                                         |
// *Salidas:                                               |
// - red, green, blue: Señales para controlar LED RGB      |
// - buzzer_out: Señal de salida para activar el buzzer    |
//_________________________________________________________|

module controlador_rgb_buzzer (
    input clk,
    input reset,
    input btn_press,        // pulso 1 ciclo: indica que se tocó algo
    input f_sig_res,        // pulso 1 ciclo: error de signo
    input overflow,         // pulso 1 ciclo: error de overflow
    input is_op1,           // señal estable
    input is_op2,           // señal estable
    input is_res,           // señal estable

    output red,
    output green,
    output blue,
    output buzzer_out
);

    // Estados latcheados de error
    reg error_f_sig_res = 0;
    reg error_overflow = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            error_f_sig_res <= 0;
            error_overflow <= 0;
        end else begin
            // Limpieza al presionar botón
            if (btn_press) begin
                error_f_sig_res <= 0;
                error_overflow <= 0;
            end

            // Latch de errores si ocurrieron
            if (f_sig_res)
                error_f_sig_res <= 1;
            if (overflow)
                error_overflow <= 1;
        end
    end

    // Selección RGB según prioridad
    reg [2:0] rgb_select;
    always @(*) begin
        if (error_f_sig_res)
            rgb_select = 3'b101;  // Rosa (Rojo + Azul)
        else if (error_overflow)
            rgb_select = 3'b100;  // Rojo
        else if (is_res)
            rgb_select = 3'b010;  // Verde
        else if (is_op1)
            rgb_select = 3'b001;  // Azul
        else if (is_op2)
            rgb_select = 3'b011;  // Cian (Verde + Azul)
        else
            rgb_select = 3'b000;  // Apagado
    end

    // LED RGB
    rgb_led_control led_control (
        .rgb_select(rgb_select),
        .red(red),
        .green(green),
        .blue(blue)
    );

    // Buzzer
    buzzer_beep #(
        .CLK_FREQ_HZ(12000000),
        .BEEP_TIME_MS(50)
    ) beep_control (
        .clk(clk),
        .reset(reset),
        .btn_press(btn_press),
        .buzzer_out(buzzer_out)
    );

endmodule



//_________________________________________________________
//                                                         |
//                    RGB LED CONTROL                      |
//_________________________________________________________|
//                                                         | 
// Descripción: Controla un LED RGB encendiendo/apagando   |
// los colores según la señal rgb_select (3 bits).         |
//_________________________________________________________|
//                                                         |
// *Entradas:                                              |
// - rgb_select [2:0]: selección de colores                |
//                                                         |
// *Salidas:                                               |
// - red, green, blue: salidas a los pines del LED         |
//_________________________________________________________|

module rgb_led_control (
    input [2:0] rgb_select,
    output red,
    output green,
    output blue
);

    assign red   = rgb_select[2];
    assign green = rgb_select[1];
    assign blue  = rgb_select[0];

endmodule


//_________________________________________________________
//                                                         |
//                       BUZZER BEEP                       |
//_________________________________________________________|
//                                                         | 
// Descripción: Módulo que activa un buzzer durante un     |
// intervalo fijo de tiempo (en ms) cada vez que se detecta|
// un pulso de btn_press.                                  |
//_________________________________________________________|
//                                                         |
// *Parámetros:                                            |
// - CLK_FREQ_HZ: Frecuencia del reloj en Hz               |
// - BEEP_TIME_MS: Duración del beep en milisegundos       |
//_________________________________________________________|
//                                                         |
// *Entradas:                                              |
// - clk: Señal de reloj                                   |
// - reset: Reset síncrono                                 |
// - btn_press: Pulso que indica que se presionó una tecla |
//_________________________________________________________|
//                                                         |
// *Salidas:                                               |
// - buzzer_out: Señal que activa el buzzer                |
//_________________________________________________________|

module buzzer_beep #(
    parameter CLK_FREQ_HZ = 12000000,        // Frecuencia de clk en Hz (ajustable)
    parameter BEEP_TIME_MS = 50             // Duración del beep en ms (ajustable)
)(
    input clk,
    input reset,
    input btn_press,
    output reg buzzer_out
);

    // Cálculo del número de ciclos de reloj que dura el beep
    localparam integer MAX_COUNT = (CLK_FREQ_HZ / 1000) * BEEP_TIME_MS;

    reg [$clog2(MAX_COUNT+1)-1:0] counter = 0;
    reg active = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            buzzer_out <= 0;
            counter <= 0;
            active <= 0;
        end else begin
            if (btn_press && !active) begin
                active <= 1;
                counter <= MAX_COUNT;
                buzzer_out <= 1;
            end else if (active) begin
                if (counter > 0)
                    counter <= counter - 1;
                else begin
                    active <= 0;
                    buzzer_out <= 0;
                end
            end
        end
    end
endmodule


