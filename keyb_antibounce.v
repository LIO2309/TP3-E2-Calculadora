//                                                                                 
//_______________________________________________________________________________________
//                                                                                       |
//                                   MÓDULO ANTIBOUNCE                                   |
//_______________________________________________________________________________________|
// *Descripción: Módulo orientado a tomar el valor del botón una vez establecido el dato |                                                |
//_______________________________________________________________________________________|
// *Entradas: -clk: señal de clock                                                       |
//            -reset: señal de reset                                                     |
//            -btn_press_in: señal de que hay algún botón presionado                     |
//                                                                                       |
// *Salidas: -enable: señal que indica si el dato decodificado del decoder proviene de un|
//                    dato esta
//_______________________________________________________________________________________|

module keyb_antibounce(
        input clk,
        input reset,
        input wire btn_press_in,
        output reg enable    
);
parameter FREQ_HZ = 50000000;
parameter DELAY = 1/1000;
parameter CLK_COUNT = DELAY/FREQ_HZ; //completar con la cuenta necesaria segun la frecuencia del clock
reg is_counting;
reg [20:0] count;
reg done;

assign enable = done;

always @(posedge clk) begin
    if(reset) begin
    count <= 0;
    is_counting <= 0;
    done <= 0;
    end
    else begin
        if (btn_press_in == 1 && !is_counting && !done) begin
            is_counting <= 1;
            count <= CLK_COUNT;
            done <= 0;
        end
        else if (btn_press_in == 0) begin
            is_counting <= 0;
            done <= 0;
        end
        else if (is_counting && count == 0) begin
            is_counting <= 0;
            done <= 1;
        end
        else if (is_counting) begin
            count <= count - 1;
            done <= 0;
        end
        
    end



end


endmodule
