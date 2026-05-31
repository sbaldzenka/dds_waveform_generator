// project : dds
// version : v1.0
// data    : 30.05.2026
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

`timescale 1ns/100ps

module triangle_form_generator
#(
    parameter F_CODE_WIDTH = 32,
    parameter DAC_WIDTH    = 8
)
(
    // global signals
    input  wire                 i_system_clk,
    input  wire                 i_system_reset,
    // control signals
    input  wire                 i_gen_enable,
    input  wire [         31:0] i_freq_code,
    // result signals
    output reg  [DAC_WIDTH-1:0] o_triangle_dds
);

    // signals
    reg [F_CODE_WIDTH-1:0] phase_accum;
    reg                    half_period_flag;
    reg [   DAC_WIDTH-1:0] saw_dds;

    // logic
    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            phase_accum <= 'b0;
        end else begin
            if (i_gen_enable) begin
                phase_accum <= phase_accum + i_freq_code;
            end else begin
                phase_accum <= 'b0;
            end
        end
    end

    always @(posedge i_system_clk) begin
        half_period_flag <= phase_accum[F_CODE_WIDTH-1];
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            saw_dds <= {DAC_WIDTH{1'b0}};
        end else begin
            saw_dds <= phase_accum[F_CODE_WIDTH-1:F_CODE_WIDTH-DAC_WIDTH];
        end
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            o_triangle_dds <= {DAC_WIDTH{1'b0}};
        end else begin
            if (half_period_flag) begin
                o_triangle_dds <= ~{saw_dds[DAC_WIDTH-2:0], 1'b0};
            end else begin
                o_triangle_dds <= {saw_dds[DAC_WIDTH-2:0], 1'b0};
            end
        end
    end

endmodule