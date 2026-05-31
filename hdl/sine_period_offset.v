// project : dds
// version : v1.0
// data    : 30.05.2026
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

module sine_period_offset
#(
    parameter DAC_WIDTH = 8
)
(
    // global signals
    input  wire                 i_system_clk,
    input  wire                 i_system_reset,
    // control
    input  wire                 i_zero_crossing,
    input  wire [DAC_WIDTH-1:0] i_dds_data,
    // result
    output reg  [DAC_WIDTH-1:0] o_dds_data
);

    // signals
    reg zero_crossing_ff;

    // logic
    always @(posedge i_system_clk) begin
        zero_crossing_ff <= i_zero_crossing;

        if (i_system_reset) begin
            o_dds_data[  DAC_WIDTH-1] <= 1'b0;
            o_dds_data[DAC_WIDTH-2:0] <= 'b1;
        end else begin
            if (zero_crossing_ff) begin
                o_dds_data <= i_dds_data;
            end else begin
                o_dds_data <= ~i_dds_data;
            end
        end
    end

endmodule