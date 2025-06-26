module top(
    input is_num,
    input is_op1,
    input is_op2,
    input [3:0] num_val,
    input [3:0] op_val,
    input save,

    output [15:0] op1_bin,
    output [15:0] op2_bin,
    output [15:0] alu_result_bcd,
    output f_OF,
    output f_sig_res
);

    reg rstn;
    wire clk;

//----------------------------------------------------------------------------
//                                                                          --
//                       Internal Oscillator                                --
//                                                                          --
//----------------------------------------------------------------------------
    SB_HFOSC  u_SB_HFOSC(.CLKHFPU(1), .CLKHFEN(1), .CLKHF(clk));
    defparam u_SB_HFOSC.CLKHF_DIV = "0b10 ";   //para obtener un clk de 12MHz

//----------------------------------------------------------------------------
//                                                                          --
//                      Hard Reset                                          --
//                                                                          --
//----------------------------------------------------------------------------

power_on_reset hard_rst(.clk(clk), .reset_out(rstn));


//----------------------------------------------------------------------------
//                                                                          --
//                      Teclado con Decoder                                 --
//                                                                          --
//----------------------------------------------------------------------------
// Señales internas
    wire [3:0] internal_btn_out;
    wire internal_btn_pressed;
    //valores sin pasar por el flip flop de control de antibounce y antirepeat
    reg is_op;
    reg is_eq;
    reg [3:0] num_val;
    reg [1:0] op_val;
    reg clear;
    reg decoder_btn_pressed;   //salida propia del decoder
    //valores saliendo por el flip flop de control de antibounce y antirepeat
    reg is_op_filter;
    reg is_eq_filter;
    reg [3:0] num_val_filter;
    reg [1:0] op_val_filter;
    reg clear_filter;
    reg btn_pressed_filter;
    //enables
    reg enable_antibounce;
    reg enable_antirepeat;


    // Conexión del controlador del teclado
    keyb_controller kc (
        .clk(clk),
        .reset(rstn),
        .rows(),                                //completar con teclado posta
        .cols(),                                //completar con teclado posta
        .btn_pressed(internal_btn_pressed),
        .btn_out(internal_btn_out)
    );

    // Conexión del decodificador
    keyb_decoder kd (
        .clk(clk),
        .reset(rstn),
        .btn_press_in(internal_btn_pressed),
        .btn_id(internal_btn_out),
        .is_num(is_num),
        .is_op(is_op),
        .is_eq(is_eq),
        .num_val(num_val),
        .op_val(op_val),
        .clear(clear),
        .btn_pressed(decoder_btn_pressed)
    );

    keyb_antibounce kab (
        .clk(clk),
        .reset(rstn),
        .btn_press_in(decoder_btn_pressed),
        .enable(enable_antibounce)
    );

    keyb_antirepeat kar (
        .enable_filter(enable_antibounce),
        .reset(rstn),
        .clk(clk),
        .enable_real(enable_antirepeat)
    );

    d_ff_decoder ff_dec(
        .clk(clk),
        .reset(rstn),
        .en(enable_antirepeat),
        .is_num_in(is_num),
        .is_op_in(is_op),
        .is_eq_in(is_eq),
        .num_val_in(num_val),
        .op_val_in(op_val),
        .clear_in(clear),
        .btn_pressed_in(decoder_btn_pressed),
        .is_num(is_num_filter),
        .is_op(is_op_filter),
        .is_eq(is_eq_filter),
        .num_val(num_val_filter),
        .op_val(op_val_filter),
        .clear(clear_filter),
        .btn_pressed(btn_pressed_filter)
);
//----------------------------------------------------------------------------
//        hay que sacar los filter para los otros modulos                   --
//            reg is_op_filter;                                             --
 //   reg is_eq_filter;                                                     --
// reg [3:0] num_val_filter;
//   reg [1:0] op_val_filter;
  //  reg clear_filter;
   // reg btn_pressed_filter;                                               --
//                                                                          --
//----------------------------------------------------------------------------


//----------------------------------------------------------------------------
//                                                                          --
//                      FSM 1                                               --
//                                                                          --
//----------------------------------------------------------------------------


    // Dígitos operandos BCD
    wire [3:0] op1_d0, op1_d1, op1_d2, op1_d3;
    wire [3:0] op2_d0, op2_d1, op2_d2, op2_d3;

    wire [15:0] op1_bcd = {op1_d3, op1_d2, op1_d1, op1_d0};
    wire [15:0] op2_bcd = {op2_d3, op2_d2, op2_d1, op2_d0};

    // Conversión BCD a binario 14 bits
    wire [13:0] op1_bin_14;
    wire [13:0] op2_bin_14;

    BCD_bn conv_op1 (
        .num_BCD(op1_bcd),
        .num_bin(op1_bin_14)
    );

    BCD_bn conv_op2 (
        .num_BCD(op2_bcd),
        .num_bin(op2_bin_14)
    );

    // ALU Core con suma y resta
    wire [13:0] res_suma_bin, res_resta_bin;
    wire f_OF_alu, f_sig_res_alu;

    alu_core alu_inst(
        .op1(op1_bin_14),
        .op2(op2_bin_14),
        .op_val(op_val),
        .res_suma(res_suma_bin),
        .res_resta(res_resta_bin),
        .f_OF(f_OF_alu),
        .f_sig_res(f_sig_res_alu)
    );

    // Mux y conversor BCD
    wire [15:0] res_bcd;
    wire [3:0] res_d3, res_d2, res_d1, res_d0;

    mux_and_bcd_converter mux_bcd_inst(
        .res_suma_bin(res_suma_bin),
        .res_resta_bin(res_resta_bin),
        .operator(op_val == 4'b1101), // suma
        .is_res(save),
        .result_bcd(res_bcd),
        .res_d3(res_d3),
        .res_d2(res_d2),
        .res_d1(res_d1),
        .res_d0(res_d0)
    );

    // FSM memory para almacenamiento
    fsm_memory mem_inst(
        .clk(clk),
        .rst_n(rst_n),
        .is_num(is_num),
        .is_op1(is_op1),
        .is_op2(is_op2),
        .save(save),
        .num_val(num_val),
        .res_d0(res_d0),
        .res_d1(res_d1),
        .res_d2(res_d2),
        .res_d3(res_d3),
        .cnt(),
        .block(),
        .op1_d0(op1_d0),
        .op1_d1(op1_d1),
        .op1_d2(op1_d2),
        .op1_d3(op1_d3),
        .op2_d0(op2_d0),
        .op2_d1(op2_d1),
        .op2_d2(op2_d2),
        .op2_d3(op2_d3)
    );

    // Salidas para testbench o debug
    assign op1_bin = {2'b00, op1_bin_14};
    assign op2_bin = {2'b00, op2_bin_14};
    assign alu_result_bcd = res_bcd;
    assign f_OF = f_OF_alu;
    assign f_sig_res = f_sig_res_alu;


//----------------------------------------------------------------------------
//                                                                          --
//    EFECTOS VISUALES/SONOROS                                              --
//                                                                          --
//----------------------------------------------------------------------------

    wire red, green, blue, buzzer_out;
    wire reset = ~rstn;

    controlador_rgb_buzzer control_vis_son (
        .clk(clk),
        .reset(reset),
        .btn_press(decoder_btn_pressed), // pulso de 1 ciclo cuando se toca algo
        .f_sig_res(f_sig_res_alu),       // salida de la ALU
        .overflow(f_OF_alu),             // salida de la ALU
        .is_op1(is_op1),
        .is_op2(is_op2),
        .is_res(save),                   // se activa cuando se muestra el resultado
        .red(red),
        .green(green),
        .blue(blue),
        .buzzer_out(buzzer_out)
    );

endmodule
