//_________________________________________________________
//                                                         |
//                   BINARIO A BCD                         |
//             Algoritmo Double Dabble (combinacional)     |
//_________________________________________________________|
//                                                         | 
// Descripción: Módulo combinacional que convierte un      |
// número binario de 16 bits a BCD (4 dígitos).            |
// Implementa el algoritmo shift-and-add-3 (Double Dabble).|
//_________________________________________________________|
//                                                         |
// *Entradas:                                              |
//   - num_bin: número binario de 16 bits                  |
//                                                         |
// *Salidas:                                               |
//   - num_BCD: número BCD de 16 bits (4 dígitos)          |
//_________________________________________________________|

module bin_to_bcd_double_dabble(
    input wire [15:0] num_bin,
    output reg [15:0] num_BCD
);
    integer i;
    reg [27:0] shift_reg; // 16 bits binario + 12 bits para 4 dígitos BCD

    always @(*) begin
        // Inicializamos el registro con binario en los 16 bits bajos
        shift_reg = 28'b0;
        shift_reg[15:0] = num_bin;

        // Iteramos 16 veces
        for (i = 15; i >= 0; i = i - 1) begin
            // Si algún nibble BCD es >= 5, se le suma 3
            if (shift_reg[19:16] >= 5) shift_reg[19:16] = shift_reg[19:16] + 3;
            if (shift_reg[23:20] >= 5) shift_reg[23:20] = shift_reg[23:20] + 3;
            if (shift_reg[27:24] >= 5) shift_reg[27:24] = shift_reg[27:24] + 3;
            if (shift_reg[15:12] >= 5) shift_reg[15:12] = shift_reg[15:12] + 3;

            // Desplazamos todo un bit a la izquierda
            shift_reg = shift_reg << 1;
        end

        // Tomamos los 4 nibbles BCD de la parte alta
        num_BCD = shift_reg[27:12];
    end

endmodule
