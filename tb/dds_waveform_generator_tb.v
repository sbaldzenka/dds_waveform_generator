// project     : dds_waveform_generator
// version     : 1.0
// data        : 04.06.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/dds_waveform_generator

`timescale 1ns/100ps

`include "test_param.vh"

module dds_waveform_generator_tb
#(
    // simulation parameters
    parameter PERIOD_CLK      = `PERIOD_CLK,
    // dds parameters
    parameter F_CODE_WIDTH    = `F_CODE_WIDTH,
    parameter DAC_WIDTH       = `DAC_WIDTH,
    parameter BRAM_ADDR_WIDTH = `BRAM_ADDR_WIDTH,
    parameter SINE_TABLE_FILE = `SIN_TABLE
);

    // signals
    reg                  system_clk;
    reg                  system_reset;

    reg  [DAC_WIDTH-1:0] amp_value;
    reg  [          5:0] signal_selector;

    wire [DAC_WIDTH-1:0] dds;

    initial begin
        #0   system_clk   = 1'b0;
             system_reset = 1'b1;
        #200 system_reset = 1'b0;
    end

    always #(PERIOD_CLK / 2) system_clk = ~system_clk;

    initial begin
        #0;
        signal_selector = 8'h00;
        amp_value       = {DAC_WIDTH{1'b0}};

        #300;
        signal_selector = `WAVEFORM;
        amp_value[7:0]  = 8'h7F;

        #1000000;
        amp_value[7:0]  = 8'h0F;

        #1000000;
        amp_value[7:0]  = 8'hFF;

        #1000000;
        amp_value       = {DAC_WIDTH{1'b1}};
    end

    dds_waveform_generator
    #(
        .F_CODE_WIDTH    ( F_CODE_WIDTH    ),
        .DAC_WIDTH       ( DAC_WIDTH       ),
        .BRAM_ADDR_WIDTH ( BRAM_ADDR_WIDTH ),
        .SINE_TABLE_FILE ( SINE_TABLE_FILE )
    )
    DUT_inst
    (
        .i_system_clk      ( system_clk      ),
        .i_system_reset    ( system_reset    ),
        .i_signal_selector ( signal_selector ),
        .i_freq_code       ( `FREQ_CODE      ),
        .i_amp_value       ( amp_value       ),
        .o_dds             ( dds             )
    );

endmodule