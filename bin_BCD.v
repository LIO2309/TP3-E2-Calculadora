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
//   - num_bin: número binario de 14 bits                  |
//                                                         |
// *Salidas:                                               |
//   - num_BCD: número BCD de 16 bits (4 dígitos)          |
//_________________________________________________________|

module bin_BCD(
    input wire [13:0] num_bin,
    output reg [15:0] num_BCD
);
    integer i;
    reg [29:0] shift_reg; // 16 bits binario + 12 bits para 4 dígitos BCD

    always @(*) begin
        // Inicializamos el registro con binario en los 16 bits bajos
        shift_reg = 30'b0;
        shift_reg[13:0] = num_bin;

        // Iteramos 16 veces
        for (i = 13; i >= 0; i = i - 1) begin
            // Si algún nibble BCD es >= 5, se le suma 3
            if (shift_reg[17:14] >= 5) shift_reg[17:14] = shift_reg[17:14] + 3;
            if (shift_reg[21:18] >= 5) shift_reg[21:18] = shift_reg[21:18] + 3;
            if (shift_reg[25:22] >= 5) shift_reg[25:22] = shift_reg[25:22] + 3;
            if (shift_reg[29:26] >= 5) shift_reg[29:26] = shift_reg[29:26] + 3;

            // Desplazamos todo un bit a la izquierda
            shift_reg = shift_reg << 1;
        end

        // Tomamos los 4 nibbles BCD de la parte alta
        num_BCD = shift_reg[29:14];
    end

endmodule
