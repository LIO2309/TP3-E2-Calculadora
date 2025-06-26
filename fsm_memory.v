module fsm_memory(
    input clk,
    input rst_n,
    input is_num,
    input is_op1,
    input is_op2,
    input save,
    input [3:0] num_val,
    input [3:0] res_d0,
    input [3:0] res_d1,
    input [3:0] res_d2,
    input [3:0] res_d3,
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

    reg just_saved = 0; // <- Nuevo flag

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            op1_d0 <= 0; op1_d1 <= 0; op1_d2 <= 0; op1_d3 <= 0;
            op2_d0 <= 0; op2_d1 <= 0; op2_d2 <= 0; op2_d3 <= 0;
            cnt_op1 <= 0; cnt_op2 <= 0;
            cnt <= 0;
            block <= 0;
            prev_is_op1 <= 0;
            prev_is_op2 <= 0;
            just_saved <= 0;
        end else begin
            // ------------------- CARGA EXTERNA (SAVE) -------------------
            if (save) begin
                op1_d0 <= res_d0;
                op1_d1 <= res_d1;
                op1_d2 <= res_d2;
                op1_d3 <= res_d3;
                cnt_op1 <= 2'd3;
                cnt     <= 2'd3;
                block   <= 1;
                just_saved <= 1; // <- Activar flag de que se hizo un save
            end

            // ------------------- CAMBIO DE OPERANDO -------------------
            else if ((is_op1 && !prev_is_op1) || (just_saved && is_op1)) begin
                op1_d0 <= 0; op1_d1 <= 0; op1_d2 <= 0; op1_d3 <= 0;
                cnt_op1 <= 0;
                cnt <= 0;
                block <= 0;
                just_saved <= 0; // <- Limpiar flag tras cambio a op1
            end else if (is_op2 && !prev_is_op2) begin
                op2_d0 <= 0; op2_d1 <= 0; op2_d2 <= 0; op2_d3 <= 0;
                cnt_op2 <= 0;
                cnt <= 0;
                block <= 0;
            end

            // ------------------- CARGA MANUAL -------------------
            if (is_num) begin
                if (is_op1 && !block) begin
                    case (cnt_op1)
                        2'd0: op1_d0 <= num_val;
                        2'd1: op1_d1 <= num_val;
                        2'd2: op1_d2 <= num_val;
                        2'd3: op1_d3 <= num_val;
                    endcase
                    if (cnt_op1 < 3) cnt_op1 <= cnt_op1 + 1;
                    if (cnt_op1 == 3) block <= 1;
                    cnt <= cnt_op1;
                end else if (is_op2 && !block) begin
                    case (cnt_op2)
                        2'd0: op2_d0 <= num_val;
                        2'd1: op2_d1 <= num_val;
                        2'd2: op2_d2 <= num_val;
                        2'd3: op2_d3 <= num_val;
                    endcase
                    if (cnt_op2 < 3) cnt_op2 <= cnt_op2 + 1;
                    if (cnt_op2 == 3) block <= 1;
                    cnt <= cnt_op2;
                end
            end

            // Flancos
            prev_is_op1 <= is_op1;
            prev_is_op2 <= is_op2;
        end
    end

endmodule
