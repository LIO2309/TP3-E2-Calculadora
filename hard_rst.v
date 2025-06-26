module power_on_reset #(
    parameter DELAY_CYCLES = 16  // Cantidad de ciclos de clk que durará el reset
)(
    input wire clk,
    output reg reset_out
);

    reg [$clog2(DELAY_CYCLES):0] reset_cnt = 0;

    always @(posedge clk) begin
        if (reset_cnt < DELAY_CYCLES) begin
            reset_cnt <= reset_cnt + 1;
            reset_out <= 1;
        end else begin
            reset_out <= 0;
        end
    end

endmodule