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
    input wire clk, is_num, is_eq, is_op, clear;   
    output reg is_op1, is_op2, is_res, save, reset;              

    reg [3:0] curr_state, next_state;

    // Asignacion de estados
    parameter [3:0] RST = 4'b0111;
    parameter [3:0] COLOCANDO_OP1 = 4'b0010;
    parameter [3:0] ESPERANDO_OP2 = 4'b0011;
    parameter [3:0] COLOCANDO_OP2 = 4'b0100;
    parameter [3:0] GUARDA = 4'b0110;
    parameter [3:0] RESULTADO = 4'b0101;
    parameter [3:0] ESPERANDO = 4'b1000;

    // Logica de proximo estado (combinacional)
    // Recordar SIEMPRE definir el proximo estado para TODAS las 
    // combinaciones posibles de Entradas y Estado Actual
    // Recomendacion: usar if/else de tal manera que el else capture
    // todas las combinaciones que no son explicitas    
    always @(is_num, is_eq, is_op, clear, curr_state)
        case (curr_state)
            RST: begin 
                    //no condicional
                    next_state <= COLOCANDO_OP1;
                end
            COLOCANDO_OP1: begin 
                    if (clear == 1 || is_num == 1) next_state <= COLOCANDO_OP1;
                    else if (is_op ==1) next_state <= ESPERANDO_OP2;
                    else next_state <= COLOCANDO_OP1;
                end
            ESPERANDO_OP2: begin
                    if (is_num == 1) next_state <= COLOCANDO_OP2;
                    else if(clear == 1) next_state <= RST;
                    else next_state <= ESPERANDO_OP2;
                end
            COLOCANDO_OP2: begin
                    if (is_eq == 1) next_state <= RESULTADO;
                    else if (clear == 1) next_state <= ESPERANDO_OP2;
                    else if (is_num == 1) next_state <= COLOCANDO_OP2;
                    else next_state <= COLOCANDO_OP2;
                end
            GUARDA: begin
                    //no condicional
                    next_state <= ESPERANDO_OP2;
                end
            RESULTADO: begin
                    //no condicional
                    next_state <= ESPERANDO;
                end
            ESPERANDO: begin
                    if (clear == 1) next_state <= RST;
                    else if (is_op == 1) next_state <= GUARDA;
                    else if (is_num == 1) next_state <= COLOCANDO_OP1;
                    else next_state <= ESPERANDO;
                end                
            default: begin
                    next_state <= RST;
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
			if (curr_state == RST)
				begin
                    reset <= 1;
                    is_op1 <= 0;
                    is_op2 <= 0;
                    is_res <= 0;
                    save <= 0;
				end
			else if (curr_state == COLOCANDO_OP1)	
				begin
					reset <= 0;
                    is_op1 <= 1;
                    is_op2 <= 1;
                    is_res <= 0;
                    save <= 0;
				end
            else if (curr_state == ESPERANDO_OP2)	
				begin
					reset <= 0;
                    is_op1 <= 0;
                    is_op2 <= 1;
                    is_res <= 0;
                    save <= 0; 
				end
            else if (curr_state == COLOCANDO_OP2)	
				begin
					reset <= 0;
                    is_op1 <= 0;
                    is_op2 <= 1;
                    is_res <= 0;
                    save <= 0;
				end
            else if (curr_state == GUARDA)	
				begin
					reset <= 0;
                    is_op1 <= 0;
                    is_op2 <= 0;
                    is_res <= 0;
                    save <= 1;
                end
            else if (curr_state == RESULTADO)	
				begin
					reset <= 0;
                    is_op1 <= 0;
                    is_op2 <= 0;
                    is_res <= 1;
                    save <= 0;
				end
            else if (curr_state == ESPERANDO)	
				begin
					reset <= 0;
                    is_op1 <= 1;
                    is_op2 <= 0;
                    is_res <= 1;
                    save <= 0;
				end
			else	 
            // Pone las salidas como en RST
				begin
                    reset <= 1;
                    is_op1 <= 0;
                    is_op2 <= 0;
                    is_res <= 0;
                    save <= 0;
				end
		end
endmodule