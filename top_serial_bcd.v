//_________________________________________________________
//                                                         |
//                   TOP SERIAL BCD TX                     |
//_________________________________________________________|
//                                                         | 
// Descripción: Módulo superior que permite seleccionar uno|
// de tres operandos en BCD de 16 bits (op1, op2 o res),   |
// y transmitirlo de forma serial al presionar un botón.   |
// La transmisión se inicia tras un retardo de 2 ciclos y  |
// se realiza un bit por ciclo, comenzando por el LSB.     |
//_________________________________________________________|
//                                                         |
// *Entradas:                                              |
// - clk: Señal de reloj                                   |
// - btn_press: Pulso de entrada (1 ciclo) que inicia el   |
//   envío                                                 |
// - is_op1: Señal que selecciona el operando op1          |
// - is_op2: Señal que selecciona el operando op2          |
// - is_res: Señal que selecciona el operando res          |
// - op1: Operando 1 en BCD (16 bits)                      |
// - op2: Operando 2 en BCD (16 bits)                      |
// - res: Resultado en BCD (16 bits)                       |
//_________________________________________________________|
//                                                         |
// *Salidas:                                               |
// - data: Salida serial (1 bit por ciclo)                 |
// - data_enable: Pulso de habilitación de transmisión     |
// - busy: Señal activa mientras se transmite              |
// - done: Pulso de un ciclo al finalizar la transmisión   |
//_________________________________________________________|

module top_serial_bcd (
    input wire clk,
    input wire reset,
    input wire btn_press,
    input wire is_op1,
    input wire is_op2,
    input wire is_res,
    input wire [15:0] op1,
    input wire [15:0] op2,
    input wire [15:0] res,
    output wire data,           // salida serial renombrada
    output wire data_enable,    // nueva salida para mostrar enable
    output wire busy,
    output wire done
);

    // Multiplexor para elegir qué dato enviar
    wire [15:0] data_no_serial;
    assign data_no_serial = is_res ? res :
                            is_op2 ? op2 :
                            is_op1 ? op1 :
                                     16'b0;

    // Pulso para habilitar la transmisión: delay de 2 ciclos, duración 16 ciclos
    pulse_delay_extend #(
        .M(2),
        .N(18)
    ) pulse_gen (
        .clk(clk),
        .rst(reset),        // Reset desconectado, fijado a 0
        .pulse_in(btn_press),
        .pulse_out(data_enable)
    );

    // Transmisión serial
    simple_serial_tx serial_tx (
        .clk(clk),
        .reset(reset),
        .enable(data_enable),
        .data_to_show(data_no_serial),
        .serial_out(data),  // salida renombrada
        .busy(busy),
        .done(done)
    );

endmodule



//
//_________________________________________________________
//                                                         |
//                 PULSE DELAY & EXTENDER                  |
//_________________________________________________________|
//                                                         | 
// Descripción: Módulo orientado a detectar un pulso de    |
// entrada, esperar M ciclos de reloj, y luego generar un  |
// pulso de salida de N ciclos de duración.                |
//_________________________________________________________|
//                                                         |
// *Parámetros:                                            |
// - M: Retardo en ciclos de reloj                         |
// - N: Duración del pulso de salida en ciclos de reloj    |
//_________________________________________________________|
//                                                         |
// *Entradas:                                              |
// - clk: Señal de reloj                                   |
// - rst: Reset síncrono                                   |
// - pulse_in: Pulso de entrada de 1 ciclo de duración     |
//_________________________________________________________|
//                                                         |
// *Salidas:                                               |
// - pulse_out: Señal de salida extendida N ciclos         |
//_________________________________________________________|

module pulse_delay_extend #(
    parameter M = 5,           // Retardo en ciclos
    parameter N = 10           // Duración del pulso de salida
)(
    input wire clk,            // Reloj
    input wire rst,            // Reset síncrono
    input wire pulse_in,       // Pulso de entrada (1 ciclo)
    output reg pulse_out       // Pulso de salida extendido
);

    // Estados internos
    reg [$clog2(M+1)-1:0] delay_cnt = 0;
    reg [$clog2(N+1)-1:0] width_cnt = 0;
    reg delaying = 0;
    reg extending = 0;

    always @(posedge clk) begin
        if (rst) begin
            delay_cnt <= 0;
            width_cnt <= 0;
            delaying <= 0;
            extending <= 0;
            pulse_out <= 0;
        end else begin
            // Fase 1: detectar pulso y comenzar retardo
            if (pulse_in && !delaying && !extending) begin
                delaying <= 1;
                delay_cnt <= 1;
            end

            // Fase 2: contar retardo
            if (delaying) begin
                if (delay_cnt == M) begin
                    delaying <= 0;
                    extending <= 1;
                    width_cnt <= 1;
                    pulse_out <= 1;
                end else begin
                    delay_cnt <= delay_cnt + 1;
                end
            end

            // Fase 3: contar extensión
            if (extending) begin
                if (width_cnt == N) begin
                    extending <= 0;
                    pulse_out <= 0;
                end else begin
                    width_cnt <= width_cnt + 1;
                end
            end
        end
    end

endmodule




//_________________________________________________________
//                                                         |
//                  SERIAL TX SIMPLE                       |
//_________________________________________________________|
//                                                         | 
// Descripción: Módulo orientado a emitir un número de 16  |
// bits de forma serial, un bit por ciclo de reloj,        |
// comenzando por el bit menos significativo.              |
//_________________________________________________________|
//                                                         |
// *Entradas:                                              |
// - clk: Señal de reloj                                   |
// - reset: Reset síncrono                                 |
// - enable: Pulso que inicia la transmisión               |
// - data_to_show: Número de 16 bits a transmitir          |
//_________________________________________________________|
//                                                         |
// *Salidas:                                               |
// - serial_out: Línea de salida serial (un bit a la vez)  |
// - busy: Señal alta mientras se transmite                |
// - done: Pulso alto por un ciclo al finalizar transmisión|
//_________________________________________________________|

module simple_serial_tx (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [15:0] data_to_show,
    output reg serial_out,
    output reg busy,
    output reg done
);

    reg [15:0] shift_reg;
    reg [4:0] bit_count;



    always @(posedge clk) begin
        if (reset) begin
            busy <= 0;
            done <= 0;
            bit_count <= 0;
            serial_out <= 0;
            shift_reg <= 0;
        end else begin
            if (enable && !busy) begin
                // Arranca transmisión
                shift_reg <= data_to_show;
                busy <= 1;
                done <= 0;
                bit_count <= 0;


            end else if (busy) begin
                // Emitimos un bit por ciclo
                serial_out <= shift_reg[0];
                shift_reg <= shift_reg >> 1;
                bit_count <= bit_count + 1;

                if (bit_count == 16) begin
                    busy <= 0;
                    done <= 1;
                end
            end else begin
                done <= 0;
            end
        end
    end
endmodule

