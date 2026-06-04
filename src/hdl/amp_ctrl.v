// project     : dds_waveform_generator
// version     : 1.0
// data        : 04.06.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/dds_waveform_generator

`timescale 1ns/100ps

module amp_ctrl
#(
    parameter DAC_WIDTH = 10
)
(
    // global signals
    input  wire                 i_system_clk,
    // control
    input  wire [DAC_WIDTH-1:0] i_amp_value,
    //
    input  wire [DAC_WIDTH-1:0] i_signal,
    output wire [DAC_WIDTH-1:0] o_signal
);

    // signals
    reg [2*DAC_WIDTH-1:0] result;

    always @(posedge i_system_clk) begin
        result <= (i_amp_value * i_signal) >> DAC_WIDTH;
    end

    assign o_signal = result[DAC_WIDTH-1:0];

endmodule