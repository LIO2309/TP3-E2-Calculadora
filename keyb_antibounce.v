//                                                                                 
//_______________________________________________________________________________________
//                                                                                       |
//                                   MÓDULO ANTIBOUNCE                                   |
//_______________________________________________________________________________________|
// *Descripción: Módulo orientado a tomar el valor del botón una vez establecido el dato |                                                
//_______________________________________________________________________________________|
// *Entradas: -clk: señal de clock                                                       |
//            -reset: señal de reset                                                     |
//            -btn_press_in: señal de que hay algún botón presionado                     |
//                                                                                       |
// *Salidas: -enable: señal que indica si el dato decodificado del decoder proviene de un|
//                    dato esta                                                          |
//_______________________________________________________________________________________|

module keyb_antibounce (
    input wire clk,
    input wire reset,
    input wire btn_press_in,
    output reg enable
);

    // Parámetros
    parameter integer FREQ_HZ = 12000000;  // 12 MHz
    parameter integer DELAY_MS = 1;         // 1 ms de delay
    parameter integer CLK_COUNT = (FREQ_HZ / 1000) * DELAY_MS; // ciclos para 1 ms delay

    // Registro para contar ciclos
    reg [20:0] count;      // 21 bits para 2 millones aprox (suficiente)
    reg btn_sync_0, btn_sync_1; // para sincronizar btn_press_in al clk
    reg btn_prev;

    // Sincronización de btn_press_in para evitar metastabilidad
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_sync_0 <= 0;
            btn_sync_1 <= 0;
            btn_prev <= 0;
        end else begin
            btn_sync_0 <= btn_press_in;
            btn_sync_1 <= btn_sync_0;
            btn_prev <= btn_sync_1;
        end
    end

    wire btn_rising_edge = (btn_sync_1 & ~btn_prev); // flanco de subida detectado

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            enable <= 0;
        end else begin
            if (btn_rising_edge) begin
                // Empezar el conteo al detectar flanco de subida
                count <= CLK_COUNT;
                enable <= 0;
            end else if (count > 0) begin
                // Contar hacia abajo
                count <= count - 1;
                enable <= 0;
            end else if (count == 0 && btn_sync_1) begin
                // Después de delay, y si botón sigue presionado, habilitar enable
                enable <= 1;
            end else begin
                enable <= 0;
            end
        end
    end

endmodule