// project : dds
// version : v1.0
// data    : 30.05.2026
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

`timescale 1ns/100ps

module square_form_generator
#(
    parameter DAC_WIDTH = 8
)
(
    // global signals
    input  wire                 i_system_clk,
    input  wire                 i_system_reset,
    // control signals
    input  wire                 i_gen_enable,
    input  wire [         31:0] i_freq_code,
    // result signals
    output reg  [DAC_WIDTH-1:0] o_square_dds
);

    // signals
    reg [31:0] phase_accum;

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
        if (i_system_reset) begin
            o_square_dds <= {DAC_WIDTH{1'b0}};
        end else begin
            if (phase_accum[31]) begin
                o_square_dds <= {DAC_WIDTH{1'b1}};
            end else begin
                o_square_dds <= {DAC_WIDTH{1'b0}};
            end
        end
    end

endmodule