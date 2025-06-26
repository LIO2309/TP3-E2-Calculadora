module mux_and_bcd_converter (
    input wire [13:0] res_suma_bin,
    input wire [13:0] res_resta_bin,
    input wire operator,       // Selector entre suma (1) y resta (0)
    input wire is_res,         // Selector para pasar resultado o cero

    output wire [15:0] result_bcd, // Salida BCD completa (16 bits)
    output reg [3:0] res_d3,       // Dígitos BCD individuales
    output reg [3:0] res_d2,
    output reg [3:0] res_d1,
    output reg [3:0] res_d0
);

    wire [13:0] selected_result;
    assign selected_result = (operator) ? res_suma_bin : res_resta_bin;

    wire [15:0] raw_bcd_result;

    bin_BCD bcd_converter (
        .num_bin(selected_result),
        .num_BCD(raw_bcd_result)
    );

    assign result_bcd = raw_bcd_result;

    wire [15:0] muxed_bcd_out;
    assign muxed_bcd_out = (is_res) ? raw_bcd_result : 16'b0;

    always @(*) begin
        res_d3 = muxed_bcd_out[15:12];
        res_d2 = muxed_bcd_out[11:8];
        res_d1 = muxed_bcd_out[7:4];
        res_d0 = muxed_bcd_out[3:0];
    end

endmodule