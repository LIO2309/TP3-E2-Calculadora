module keyb_decoder(
        input wire clk,
        input wire reset,
        input wire btn_press_in,
        input wire [3:0] btn_id,
        output reg is_number,
        output reg is_op,
        output reg is_eq,
        output reg [3:0] num_val,
        output reg [1:0] op_val,
        output reg clear,
        output reg btn_pressed   
);


    //decodifico los valores posibles - 4 bits donde los primeros 2 (menos significativos) son la filas y los siguientes 2 columnas 
    parameter [3:0] BTN_0 =    4'd7;    
    parameter [3:0] BTN_1 =    4'd0;    
    parameter [3:0] BTN_2 =    4'd4;    
    parameter [3:0] BTN_3 =    4'd8;    
    parameter [3:0] BTN_4 =    4'd1;    
    parameter [3:0] BTN_5 =    4'd5;    
    parameter [3:0] BTN_6 =    4'd9;    
    parameter [3:0] BTN_7 =    4'd2;    
    parameter [3:0] BTN_8 =    4'd6;    
    parameter [3:0] BTN_9 =    4'd10;    
    parameter [3:0] BTN_PLUS = 4'd13;    
    parameter [3:0] BTN_MIN =  4'd14;    
    parameter [3:0] BTN_EQ =   4'd15;
    parameter [3:0] BTN_CLR =  4'd12;    //Boton de clear

    //genero las salidas en base a los botones
    always @(posedge clk) begin
        if (reset) begin
            btn_pressed <= 0;
            is_number <= 0;
            is_eq <= 0;
            is_op <= 0;
            num_val <= 4'd0;
            op_val <= 2'd0;
            clear <= 0;
        end
        else if (btn_press_in) begin
            btn_pressed <= 1;
            case (btn_id)
                BTN_0: begin 
                    is_number <= 1;
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd0;
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_1: begin 
                    is_number <= 1;
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd1;
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_2: begin 
                    is_number <= 1;
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd2;
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_3: begin 
                    is_number <= 1;
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd3;
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_4: begin 
                    is_number <= 1;
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd4;
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_5: begin 
                    is_number <= 1;
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd5;
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_6: begin 
                    is_number <= 1;
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd6;
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_7: begin 
                    is_number <= 1;
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd7;
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_8: begin 
                    is_number <= 1;
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd8;
                    op_val = 2'd0;
                    clear <= 0;
                end
                BTN_9: begin 
                    is_number <= 1;
                    is_eq <= 0;
                    is_op <= 0;
                    num_val = 4'd9;
                    op_val = 2'd0;
                    clear <= 0;
                end
                                                                    
                BTN_PLUS: begin 
                    is_number <= 0;
                    is_eq <= 0;
                    is_op <= 1;
                    num_val <= 4'd0;
                    op_val <= 2'd1;
                    clear <= 0;
                end
                BTN_MIN: begin 
                    is_number <= 0;
                    is_eq <= 0;
                    is_op <= 1;
                    num_val <= 4'd0;
                    op_val <= 2'd2;
                    clear <= 0;
                end


                BTN_EQ: begin 
                    is_number <= 0;
                    is_eq <= 1;
                    is_op <= 0;
                    num_val <= 4'd0;
                    op_val <= 2'd0;
                    clear <= 0;
                end
                
                BTN_CLR: begin 
                    is_number <= 0;
                    is_eq <= 0;
                    is_op <= 0;
                    num_val <= 4'd0;
                    op_val <= 2'd0;
                    clear <= 1;
                end
                
            endcase
        end
        else begin 
                btn_pressed <= 0;
                is_number <= 0;
                is_eq <= 0;
                is_op <= 0;
                num_val <= 4'd0;
                op_val <= 2'd0;
                clear <= 0;
            end  
    end

endmodule