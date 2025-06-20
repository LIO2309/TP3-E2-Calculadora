//                                                                                 
//_______________________________________________________________________________________
//                                                                                       |
//                                   MÓDULO ANTIREPEAT                                   |
//_______________________________________________________________________________________|
// *Descripción: Módulo orientado a habilitar el valor del decodificador solo con el     |
//                flanco ascendente del enable del antibounce                            |                                                                                       
//_______________________________________________________________________________________|
// *Entradas: -clk: señal de clock                                                       |
//            -reset: señal de reset                                                     |
//            -enable_filter: señal de enable del módulo antibounce                      |
//                                                                                       |
// *Salidas: -enable_real: señal que indica si el dato decodificado del decoder proviene |
//                de un dato estable                                                     |
//                                                                                       |                           
//_______________________________________________________________________________________|

module keyb_antirepeat(
        input enable_filter,
        input reset,
        input clk,
        output reg enable_real    
);

    reg [2:1] curr_state, next_state;

    // Asignacion de estados
    parameter [1:0] A = 1'b0;
    parameter [1:0] B = 1'b1;

    // Logica de proximo estado y salida (combinacional)
    // Recordar SIEMPRE definir el proximo estado Y TODAS las salidas 
    // para TODAS las combinaciones posibles de Entradas y Estado Actual
    // Recomendacion: usar if/else de tal manera que el else capture
    // todas las combinaciones que no son explicitas
    always @(enable_filter, curr_state) begin
        case (curr_state)
            A: if (enable_filter)
                begin
                    enable_real <= 1;  
                    next_state <= B;
                end
               else
                begin
                    enable_real <= 0;
                    next_state <= A;
                end
            B: if (enable_filter)
                begin
                    enable_real <= 0;
                    next_state <= B;
                end
               else
                begin
                    enable_real <= 0; 
                    next_state <= A;
                end
        endcase
    end
    //Transicion de estado
    always @(posedge clk) begin
        if (reset == 1) begin     // Reset activo en alto
        curr_state <= A;
        end  // Estado inicial
        else begin
        curr_state <= next_state;  // Avanza al siguiente estado
        end
    end

endmodule
