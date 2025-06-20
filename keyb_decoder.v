//_______________________________________________________________________________________|
//                                   MÓDULO KEYB_DECODER                                 |
//_______________________________________________________________________________________|
// *Descripción: Módulo que decodifica la tecla presionada en un teclado matricial 4x4.  |
//  Recibe un identificador de tecla y genera señales de control según el tipo de botón  |
//  presionado (número, operación, igual o clear). Sirve como interfaz entre el teclado  |
//  y el resto del sistema lógico de la calculadora.                                     |
//_______________________________________________________________________________________|
// *Entradas: -clk: señal de reloj                                                       |
//            -reset: reinicio síncrono de todas las salidas                             |
//            -btn_press_in: señal que indica que se ha detectado una pulsación válida   |
//            -btn_id: identificador de 4 bits del botón presionado                      |
//                                                                                       |
// *Salidas: -is_num: se activa en 1 cuando el botón presionado es un número (0 al 9)    |
//           -is_op: se activa en 1 si el botón es una operación (+ o -)                 |
//           -is_eq: se activa en 1 si el botón presionado es el igual (=)               |
//           -num_val: valor numérico (0 a 9) del botón si is_num = 1                    |
//           -op_val: código de operación (01 = suma, 10 = resta) si is_op = 1           |
//           -clear: se activa en 1 si el botón presionado es "clear"                    |
//           -btn_pressed: se activa en 1 si hubo una pulsación válida                   |
//_______________________________________________________________________________________|


module keyb_decoder(
        input wire clk,              //Señal de clock
        input wire reset,            //Señal de reset que reinicia todas las salidas
        input wire btn_press_in,     //Señal que indica que se presionó un botón
        input wire [3:0] btn_id,     //Código de 4 bits que representa el botón presionado
        
        output reg is_num,           //Salida que indica si la tecla presionada es un número (0 al 9)
        output reg is_op,            //Salida que indica si la tecla presionada es una operación (+ o -)
        output reg is_eq,            //Salida que indica si la tecla presionada es el botón igual (=)
        output reg [3:0] num_val,    //Valor numérico del botón si es un númenro (0 a 9)
        output reg [1:0] op_val,     //Código del operador utilizado, 01b: sumar y 10b: restar
        output reg clear,            //Salida que indica si se presinó el botón de clear
        output reg btn_pressed       //Señal que indica si un botón fue presionado
);

    //Definción de los códigos de cada botón segun su posición en la matriz
    //Decodificación de cada botón en 4 bits. Los 2 bits menos signifcativos indican las filas y los 2 bits mas significativos son las columnas. 
    parameter [3:0] BTN_0 =    4'd7;    //Botón 0
    parameter [3:0] BTN_1 =    4'd0;    //Botón 1
    parameter [3:0] BTN_2 =    4'd4;    //Botón 2
    parameter [3:0] BTN_3 =    4'd8;    //Botón 3
    parameter [3:0] BTN_4 =    4'd1;    //Botón 4
    parameter [3:0] BTN_5 =    4'd5;    //Botón 5
    parameter [3:0] BTN_6 =    4'd9;    //Botón 6
    parameter [3:0] BTN_7 =    4'd2;    //Botón 7
    parameter [3:0] BTN_8 =    4'd6;    //Botón 8
    parameter [3:0] BTN_9 =    4'd10;   //Botón 9
    parameter [3:0] BTN_PLUS = 4'd13;   //Botón "+"
    parameter [3:0] BTN_MIN =  4'd14;   //Botón "-" 
    parameter [3:0] BTN_EQ =   4'd15;   //Botón "="
    parameter [3:0] BTN_CLR =  4'd12;    //Boton de clear


    //Se generan las salidas en base a los botones presionados.
    always @(posedge clk) begin
        if (reset) begin            //Si se activa el reset, se reincian todas las salidas
            btn_pressed <= 0;
            is_num <= 0;
            is_eq <= 0;
            is_op <= 0;
            num_val <= 4'd0;
            op_val <= 2'd0;
            clear <= 0;
        end
        else if (btn_press_in) begin        //Si se presiona algún botón, 
            btn_pressed <= 1;               //se activa la señal btn_pressed y se evalua el botón
            case (btn_id)                   //Depende del botón presionado, se realizan distintas acciones
                BTN_0: begin 
                    is_num <= 1;            //Es un número
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd0;         //Valor númerico = 0
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_1: begin 
                    is_num <= 1;            //Es un número
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd1;         //Valor númerico = 1
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_2: begin 
                    is_num <= 1;            //Es un número
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd2;         //Valor númerico = 2
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_3: begin 
                    is_num <= 1;            //Es un número
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd3;         //Valor númerico = 3
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_4: begin 
                    is_num <= 1;            //Es un número
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd4;         //Valor númerico = 4
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_5: begin 
                    is_num <= 1;            //Es un número
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd5;         //Valor númerico = 5
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_6: begin 
                    is_num <= 1;            //Es un número
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd6;         //Valor númerico = 6
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_7: begin 
                    is_num <= 1;            //Es un número
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd7;         //Valor númerico = 7
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_8: begin 
                    is_num <= 1;            //Es un número
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd8;         //Valor númerico = 8
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_9: begin 
                    is_num <= 1;            //Es un número
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd9;         //Valor númerico = 9
                    op_val = 2'd0;
                    clear <= 0;
                end
            //Casos para operaciones                                                   
                BTN_PLUS: begin 
                    is_num <= 0;
                    is_eq <= 0;
                    is_op <= 1;             //Es una operación
                    num_val <= 4'd0;
                    op_val <= 2'd1;         //Código para sumar
                    clear <= 0;
                end
                BTN_MIN: begin 
                    is_num <= 0;
                    is_eq <= 0;
                    is_op <= 1;             //Es una operación
                    num_val <= 4'd0;
                    op_val <= 2'd2;         //Código para sumar
                    clear <= 0;
                end


                BTN_EQ: begin 
                    is_num <= 0;
                    is_eq <= 1;             //Es un igual
                    is_op <= 0;
                    num_val <= 4'd0;
                    op_val <= 2'd0;
                    clear <= 0;
                end
                
                BTN_CLR: begin 
                    is_num <= 0;
                    is_eq <= 0;
                    is_op <= 0;
                    num_val <= 4'd0;
                    op_val <= 2'd0;
                    clear <= 1;            //Se activa el borrar
                end
                
            endcase
        end
        else begin 
                btn_pressed <= 0;          //Si no se presiona ningún botón, se resetean las salidas
                is_num <= 0;
                is_eq <= 0;
                is_op <= 0;
                num_val <= 4'd0;
                op_val <= 2'd0;
                clear <= 0;
            end  
    end

endmodule