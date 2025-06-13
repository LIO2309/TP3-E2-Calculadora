//                                                                                 
//_______________________________________________________________________________________
//                                                                                       |
//                                   MÓDULO FSM_OPERAND                                  |
//_______________________________________________________________________________________|
// *Descripción: Módulo orientado a determinar que operando se esta manejando y que      |
//  se tiene que mostrar en el display.                                                  |
//_______________________________________________________________________________________|
// *Entradas: -clk: señal de clock                                                       |
//            -is_num: señal que tiene un estado alto cuando se ingresa un nuevo número  |
//            -is_eq: señal que tiene un estado alto cuando se ingresa un =              |
//            -is_op: señal que tiene un estado alto cuando se ingresa un operando       |
//            -clear: señal que si se presiona una vez limpia el operando actual         |
//                   y si se presiona dos veces realiza un reset                         |
//                                                                                       |
// *Salidas: -is_op1: señal que indica que se esta modificando el operador 1 y que       |
//                    se tiene que mostrar (si is_res no esta activo)                    |
//           -is_op2: señal que indica que se esta modificando el operador 2 y que       |
//                    se tiene que  mostrar (si is_res no esta activo)                   |
//           -is_res: señal que indica que se tiene que mistrar el resultado             |
//           -save: señal que indica que se tiene que guardar el resultado en op1        |
//                  tal de operar con este                                               |
//           -reset: señal que indica que resetea todos los operadores y vuelve al op1   |
//_______________________________________________________________________________________|

module fsm_operand (clk, is_num, is_eq, is_op, clear);
    input wire clk, reset, in;   // Clock, reset, sensor inputs (async)
    output reg out;              // Control output
    //output [2:1] y;            // State output (para debug)

    reg [1:0] curr_state, next_state;

    // Asignacion de estados
    
    parameter [1:0] E1 = 2'b00;
    parameter [1:0] E2 = 2'b01;
    parameter [1:0] E3 = 2'b10;

    // Logica de proximo estado (combinacional)
    // Recordar SIEMPRE definir el proximo estado para TODAS las 
    // combinaciones posibles de Entradas y Estado Actual
    // Recomendacion: usar if/else de tal manera que el else capture
    // todas las combinaciones que no son explicitas    
    always @(in, curr_state)
        case (curr_state)
            E1: begin 
                    if (in == 1) begin
                        next_state <= E2;
                    end   
                    else begin 
                        next_state <= E1;
                    end
                end
            E2: begin 
                    if (in == 1) next_state <= E2;
                    else next_state <= E3;
                end
            E3: begin
                    if (in == 1) next_state <= E3;
                    else next_state <= E1;
                end
            default: begin
                    next_state <= E1;
                end
        endcase

    // Transicion al proximo estado (secuencial)
    always @(posedge clk)
        if (reset == 1) curr_state <= E1;
        else curr_state <= next_state;

    // Salida (combinacional)
	//assign out = (curr_state == E1) || (curr_state == E2);
	
    // Recordar siempre asignar TODAS las salidas para TODOS los estados
	always @(curr_state)
		begin
			if (curr_state == E1)
				begin
                    out <= 1;
				end
			else if (curr_state == E2)	
				begin
					out <= 0
				end
			else	 
				begin
					out <= 0;   
				end
		end
endmodule