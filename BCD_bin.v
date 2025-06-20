//
//_________________________________________________________
//                                                         |
//                        BCD-BIN                          |
//_________________________________________________________|
//                                                         | 
// Descripción: Módulo orientado a convertir números de BCD|
// a binario.                                              |
//_________________________________________________________|
//                                                         |
// *Entradas: entra un número en BCD de 16 bits (4 digitos)|
//                                                         |
// *Salidas: sale el número en binario                     |
//_________________________________________________________|

module BCD_bn(
        input wire num_BCD,
        output wire num_bin,    
);

num_bin = num_BCD[]

endmodule




//_____________________________
//          MULT_DIEZ         |
//____________________________|
// Modulo dedicado a multipli-|
// car por diez el número.    |
//____________________________|                           
// Entradas: -num_in:número a |
//         multiplicar        |
// Salidas: -num out: numero  |
//        multiplicado        |
//____________________________|

module mult_diez(
        input wire num_in,
        output wire num_out,    
);

num_out = (num_in <<< 3) + (num_in <<< 1);

endmodule



