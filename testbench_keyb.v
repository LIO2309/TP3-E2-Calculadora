`timescale 1ns/10ps

module testbench_keyb();
  reg clk, reset;
  wire [3:0] rows_in;
  reg press_btn0;
  reg press_btn1;
  reg press_btn6;
  reg press_btn8;
  reg press_btn_clr;
  
  wire [3:0] cols_out;
  
  wire is_num, is_op, is_eq, press, clear;
  wire [3:0] num_val;
  wire [1:0] op_val;
  wire btn_pressed;
  wire btn_press_col;
  wire [3:0] btn_id;
  
  keyb_controller keyb_ctrl1(clk, reset, cols_out, rows_in, btn_press_col, btn_id);
  keyb_decoder keyb_decode1(clk, reset, btn_press_col, btn_id, is_num, is_op, is_eq, num_val, op_val, clear, btn_pressed);
  
  // Simulo los switches del teclado
  assign rows_in[0] = (press_btn1 && cols_out[0]) || (press_btn_clr && cols_out[3]);
  assign rows_in[1] = (press_btn6 && cols_out[2]);
  assign rows_in[2] = (press_btn8 && cols_out[1]);
  assign rows_in[3] = (press_btn0 && cols_out[1]);  

  initial begin
    clk <= 0;
    reset <= 1;
    //rows_in <= 4'b0000;
    press_btn0 = 0;  
    press_btn1 = 0;  
    press_btn6 = 0;  
    press_btn8 = 0;
    press_btn_clr = 0;  
  end
  
  always begin
    #5 clk <= ~clk;
  end
  
  
  initial begin
    
    $dumpfile("1.vcd");
    $dumpvars(2);
    #7 reset = 0;
    
    #100 press_btn0 <= 1;
    #500 press_btn0 <= 0;
    #300 press_btn1 <= 1;
    #400 press_btn1 <= 0;
    #300 press_btn_clr <= 1;
    #20 press_btn_clr <= 0;
    #50 press_btn_clr <= 1;
    #40 press_btn_clr <= 0;
    #600 press_btn8 <= 1;
    #300 press_btn8 <= 0;
    #400 press_btn6 <= 1;
    #200 press_btn6 <= 0;

    #200 $finish;
  end
  
endmodule