//                                                                                 
//_______________________________________________________________________________________
//                                                                                       |
//                               MÓDULO MEMORY                                           |
//_______________________________________________________________________________________|
// *Descripción: Módulo orientado a almacenar los dígitos de dos operandos de 4 cifras   |
//  decimales cada uno. Se utilizan señales de control externas para definir cuál de los |
//  operandos se encuentra activo y debe recibir los nuevos números. Una vez ingresados  |
//  4 dígitos, se bloquea automáticamente la escritura hasta que se cambie de operando.   |
//  El cambio de operando reinicia el contenido del operando nuevo y desbloquea su carga.|
//_______________________________________________________________________________________|
// *Entradas: -clk: señal de clock                                                       |
//            -rst_n: reset activo en bajo. Reinicia los contadores y operandos          |
//            -is_num: pulso que indica que se ingresó un nuevo dígito                   |
//            -is_op1: activo cuando se está escribiendo el operando 1                   |
//            -is_op2: activo cuando se está escribiendo el operando 2                   |
//            -num_val: valor del dígito a ingresar (codificado en binario natural)      |
//                                                                                       |
// *Salidas: -cnt: contador interno (de 0 a 3) del dígito actual del operando activo     |
//           -block: indica que ya se han ingresado 4 dígitos y no se permiten más       |
//           -op1_d0..d3: dígitos individuales del operando 1 (de menor a mayor orden)    |
//           -op2_d0..d3: dígitos individuales del operando 2 (de menor a mayor orden)    |
//_______________________________________________________________________________________|


module dual_operand_digits(
    input clk,
    input rst_n,
    input is_num,
    input is_op1,
    input is_op2,
    input [3:0] num_val,
    output reg [1:0] cnt,
    output reg block,
    output reg [3:0] op1_d0,
    output reg [3:0] op1_d1,
    output reg [3:0] op1_d2,
    output reg [3:0] op1_d3,
    output reg [3:0] op2_d0,
    output reg [3:0] op2_d1,
    output reg [3:0] op2_d2,
    output reg [3:0] op2_d3
);

    reg prev_is_op1 = 0;
    reg prev_is_op2 = 0;

    reg [1:0] cnt_op1 = 0;
    reg [1:0] cnt_op2 = 0;

        always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset global
        op1_d0 <= 0; op1_d1 <= 0; op1_d2 <= 0; op1_d3 <= 0;
        op2_d0 <= 0; op2_d1 <= 0; op2_d2 <= 0; op2_d3 <= 0;
        cnt_op1 <= 0; cnt_op2 <= 0;
        cnt      <= 0;
        block    <= 0;
        prev_is_op1 <= 0;
        prev_is_op2 <= 0;

    end else begin
        //------------------ cambio de operando ------------------
        if (is_op1 && !prev_is_op1) begin      // flanco de activación op1
            op1_d0 <= 0; op1_d1 <= 0; op1_d2 <= 0; op1_d3 <= 0;
            cnt_op1 <= 0;
            cnt   <= 0;
            block <= 0;                       // desbloquea al entrar
        end
        if (is_op2 && !prev_is_op2) begin      // flanco de activación op2
            op2_d0 <= 0; op2_d1 <= 0; op2_d2 <= 0; op2_d3 <= 0;
            cnt_op2 <= 0;
            cnt   <= 0;
            block <= 0;                       // desbloquea al entrar
        end

        //------------------ carga de dígitos --------------------
        if (is_num) begin
            // ---------- Operando 1 ----------
            if (is_op1) begin
                if (!block) begin
                    case (cnt_op1)
                        2'd0: op1_d0 <= num_val;
                        2'd1: op1_d1 <= num_val;
                        2'd2: op1_d2 <= num_val;
                        2'd3: op1_d3 <= num_val;
                    endcase

                    if (cnt_op1 < 3)
                        cnt_op1 <= cnt_op1 + 1;

                    // bloquea justo después de almacenar el dígito 3
                    if (cnt_op1 == 3)
                        block <= 1;
                end
                cnt <= cnt_op1;   // 0‑3 indica cuántos dígitos válidos tiene op1
            end

            // ---------- Operando 2 ----------
            else if (is_op2) begin
                if (!block) begin
                    case (cnt_op2)
                        2'd0: op2_d0 <= num_val;
                        2'd1: op2_d1 <= num_val;
                        2'd2: op2_d2 <= num_val;
                        2'd3: op2_d3 <= num_val;
                    endcase

                    if (cnt_op2 < 3)
                        cnt_op2 <= cnt_op2 + 1;

                    if (cnt_op2 == 3)
                        block <= 1;
                end
                cnt <= cnt_op2;   // 0‑3 indica cuántos dígitos válidos tiene op2
            end
            // Si ninguno de los dos operandos está activo, ignora el pulso
        end
        //--------------------------------------------------------

        prev_is_op1 <= is_op1;
        prev_is_op2 <= is_op2;
    end
end


endmodule
