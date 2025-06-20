//                                                                                 
//_______________________________________________________________________________________
//                                                                                       |
//                                   MÓDULO ANTIREPEAT                                   |
//_______________________________________________________________________________________|
// *Descripción: Módulo orientado a habilitar el valor del decodificador solo con el     |
//                flanco ascendente del enable del antibounce                            |                                            |                                           
//_______________________________________________________________________________________|
// *Entradas: -clk: señal de clock                                                       |
//            -reset: señal de reset                                                     |
//            -btn_press_in: señal de que hay algún botón presionado                     |
//                                                                                       |
// *Salidas: -enable: señal que indica si el dato decodificado del decoder proviene de un|
//                    dato esta                                                          |
//_______________________________________________________________________________________|

module keyb_antirepeat(
        input enable_filter,
        output reg enable_real    
);


endmodule
