// project     : dds_waveform_generator
// version     : 1.0
// data        : 04.06.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/dds_waveform_generator

`timescale 1ns/100ps

module noise_generator
#(
    parameter DAC_WIDTH = 8
)
(
    // global signals
    input  wire                 i_system_clk,
    input  wire                 i_system_reset,
    // control signals
    input  wire                 i_gen_enable,
    // result signals
    output reg  [DAC_WIDTH-1:0] o_noise_dds
);

    // signals
    reg  [31:0] lfsr_register;
    wire        feedback;

    // logic
    assign feedback = lfsr_register[31] ^ lfsr_register[30] ^ lfsr_register[1] ^ lfsr_register[0];

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            lfsr_register <= {32{1'b1}};
        end else begin
            if (i_gen_enable) begin
                lfsr_register <= {lfsr_register[30:0], feedback};
            end else begin
                lfsr_register <= {32{1'b1}};
            end
        end
    end

    always @(posedge i_system_clk) begin
        o_noise_dds <= lfsr_register[DAC_WIDTH-1:0];
    end

endmodule