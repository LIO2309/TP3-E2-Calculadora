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
        input wire [15:0] num_BCD,
        output wire [15:0] num_bin,    
);
    //asignamos nombres convenientemente
    wire [3:0] unidades = num_BCD[3:0];
    wire [3:0] decenas  = num_BCD[7:4];
    wire [3:0] centenas = num_BCD[11:8];
    wire [3:0] miles    = num_BCD[15:12];

    //como tenemos que realizar una suma, debemos de operar con
    // la cantidad de bits finales
    wire [15:0] mult_10, mult_100, mult_1000;

    // Multiplicar decenas por 10
    mult_diez mult_inst_10 (
        .num_in({12'b0, decenas}),
        .num_out(mult_10)
    );

    // Multiplicar centenas por 100 = centenas * 10 * 10
    wire [15:0] temp_centenas; //muliplicamos por 10
    mult_diez mult_inst_100_a (
        .num_in({12'b0, centenas}),
        .num_out(temp_centenas)
    );
    mult_diez mult_inst_100_b ( //multiplicamos por 100
        .num_in(temp_centenas),
        .num_out(mult_100)
    );

    // Multiplicar miles por 1000 = miles * 10 * 10 * 10
    wire [15:0] temp_miles_1, temp_miles_2;
    mult_diez mult_inst_1000_a ( // multiplicamos por 10
        .num_in({12'b0, miles}),
        .num_out(temp_miles_1)
    );
    mult_diez mult_inst_1000_b (// multiplicamos por 100
        .num_in(temp_miles_1),
        .num_out(temp_miles_2)
    );
    mult_diez mult_inst_1000_c ( //multiplicamos por 1000
        .num_in(temp_miles_2),
        .num_out(mult_1000)
    );

    assign num_bin = unidades + mult_10 + mult_100 + mult_1000; 

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
    input wire [15:0] num_in,        
    output wire [15:0] num_out       
);

assign num_out = (num_in << 3) + (num_in << 1);  

endmodule




