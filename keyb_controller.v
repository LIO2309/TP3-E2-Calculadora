//_______________________________________________________________________________________|
//                                   MÓDULO KEYB_CONTROLLER                               |
//_______________________________________________________________________________________|
// *Descripción: Módulo que escanea un teclado matricial de 4x4 detectando qué tecla ha  |
//  sido presionada. Realiza el barrido de columnas activando de a una, detecta la fila  |
//  activa, codifica la posición de la tecla y genera una señal de tecla presionada.     |
//  Es el módulo encargado de controlar la exploración y codificación del teclado.       |
//_______________________________________________________________________________________|
// *Entradas: -clk: señal de reloj                                                       |
//            -reset: reinicio síncrono del módulo                                       |
//            -rows: vector de 4 bits que representa las filas del teclado (entradas)    |
//                                                                                       |
// *Salidas: -cols: vector de 4 bits que representa las columnas activas del teclado     |
//                  (solo una se activa por ciclo)                                       |
//           -btn_pressed: se activa en 1 cuando se detecta una tecla válida             |
//           -btn_out: código de 4 bits que identifica la tecla presionada               |
//_______________________________________________________________________________________|


module keyb_controller(
        input clk,                  //Señal de clock
        input reset,                //Señal de reset
        input wire [3:0] rows,      //Entradas desde las filas del teclado
        output reg [3:0] cols,      //Salidas para seleccionar columnas del tecaldo
        output reg btn_pressed,     //Señal que indica si se detectó una tecla presionada
        output reg [3:0] btn_out    //Código de 4 bits correspondiente a la tecla presionada
);
 
    //Variables internas
    reg first_col;                  //Flag que indica se se esta en la primera columnam, inicio del ciclo
    reg btn_press_internal;         //Flag  interno que permite detectar si se detectó una tecla presionada

    
    //Ring counter para seleccionar columnas (escaneo de columnas)
    //Activa una sola columna a la vez en cada ciclo de clock
    always @(posedge clk) begin
        if (reset) begin
            cols <= 4'b0001;            //Comienza activando la primera columna
            first_col <= 1;             //Marca que es la primera columna
        end
        else begin
            if (cols == 4'b1000) begin
                cols <= 4'b0001;        //Si estaba en la última, vuelve a la primera
                first_col <= 1;
            end
            else begin
                cols <= cols << 1;      //Activa la siguiente columna 
                first_col <= 0;
            end
        end
    end

    //Codificación de columna y fila en un ID
    wire [3:0] btn_id;                          //Vector que representa el botón presionado, codificado como {col,fila}
    
    //Se usan dos instancias del codificador enconder2_4 para covertir los bits unicos activos 
    //en las columnas y filas en indices binarios de 2 bits
    encoder2_4 enc1 (cols[3:0], btn_id[3:2]);       //Codifica que columna esta activada
    encoder2_4 enc0 (rows[3:0], btn_id[1:0]);       //Codifica que fila tiene entrada activa
 
    //Registro temporal que almacena el botón detectado
    reg [3:0] btn_store;

    //Detección de pulsación
    assign any_btn = rows[0] || rows [1] || rows [2] || rows[3];        //OR lógico que indica si hay al menos una fila activa

    //Almacenamiento del botón detectado
    always @(posedge clk) begin     //Ante flanco ascendente del clock, si hay un botón presionado se guarda el ID
        if (reset) begin
            btn_store <= 4'd0;          //Limpia el valor del botón guardado
            btn_press_internal <= 0;    //Indica que no hay botón presionado detectado
        end
        else begin
            if (any_btn) begin
                btn_store <= btn_id;        //Guarda el ID del botón
                btn_press_internal <= 1;    //Indica que hay botón presionado
            end
            else if (first_col) begin       //Si no hay botón apretado y vuelve a la primera columna, se limpia el ID
                btn_store <= 4'd0;
                btn_press_internal <= 0;                
            end
        end
        
    end

    //Generación de salida
    always @(posedge clk) begin
        if (first_col) begin                    //Solo en la primera columna se actualiza la salida
            if (btn_press_internal) begin
                btn_out <= btn_store;           //Se pasa el valor detectado a la salida
                btn_pressed <= 1;               // Marca que se detectó un botón
            end
            else if (!btn_press_internal) begin     //Si no hay detección de botón, se limpia la salida
                btn_out <= 4'd0;
                btn_pressed <= 0;
            end
        end
    end


endmodule

//_______________________________________________________________________________________|
//                                   MÓDULO ENCODER2_4                                   |
//_______________________________________________________________________________________|
// *Descripción: Módulo codificador de prioridad 4 a 2. Recibe un vector de 4 bits con   |
//  un solo bit activo e indica su posición en un vector de 2 bits. Se utiliza para      |
//  codificar la fila o columna activa en el teclado matricial.                          |
//_______________________________________________________________________________________|
// *Entradas: -in: vector de 4 bits con un solo bit en 1 (posición activa)               |
//                                                                                       |
// *Salidas: -out: vector de 2 bits con el índice del bit activo                         |
//_______________________________________________________________________________________|

module encoder2_4( 
        input wire [3:0] in,            //Entrada de 4 bits, solo un bit en 1
        output reg [1:0] out            //Salida de 2 bits con la posición del bit 1
);
    always@(*) begin
        if(in[3]) begin
            out <= 2'b11;                //Si el bit 3 está activo
        end
        else if(in[2]) begin
            out <= 2'b10                //Si el bit 2 está activo
        end
        else if(in[1]) begin
            out <= 2'b01                //Si el bit 1 está activo
        end
        else if(in[0]) begin
            out <= 2'b00                //Si el bit 0 está activo
        end
    end

endmodule