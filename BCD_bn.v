//_________________________________________________________
//                                                         |
//                        BCD-BIN                          |
//_________________________________________________________|
//                                                         | 
// Descripción: Módulo orientado a convertir números de BCD|
// a binario.                                              |
//_________________________________________________________|
// Entradas: entra un número en BCD de 16 bits (4 dígitos) |
// Salidas: sale el número en binario                     |
//_________________________________________________________|

module BCD_bn(
    input wire [15:0] num_BCD,
    output wire [13:0] num_bin  // Cambiado a 14 bits
);

    wire [3:0] unidades = num_BCD[3:0];
    wire [3:0] decenas  = num_BCD[7:4];
    wire [3:0] centenas = num_BCD[11:8];
    wire [3:0] miles    = num_BCD[15:12];

    wire [13:0] mult_10, mult_100, mult_1000;

    // Multiplicar por 10 sin función ni módulo, con 14 bits:
    assign mult_10 = ({10'b0, decenas} << 3) + ({10'b0, decenas} << 1);
    wire [13:0] temp_centenas = ({10'b0, centenas} << 3) + ({10'b0, centenas} << 1);
    assign mult_100 = (temp_centenas << 3) + (temp_centenas << 1);
    wire [13:0] temp_miles1 = ({10'b0, miles} << 3) + ({10'b0, miles} << 1);
    wire [13:0] temp_miles2 = (temp_miles1 << 3) + (temp_miles1 << 1);
    assign mult_1000 = (temp_miles2 << 3) + (temp_miles2 << 1);

    assign num_bin = {10'b0, unidades} + mult_10 + mult_100 + mult_1000;

endmodule
