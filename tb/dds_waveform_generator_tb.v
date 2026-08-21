/*
---------------------------------------------------------------------------------------

MIT License

Copyright (c) 2026 Siarhei Baldzenka

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---------------------------------------------------------------------------------------

project     : dds_waveform_generator
version     : 1.0
data        : 04.06.2026
author      : siarhei baldzenka
e-mail      : sbaldzenka@proton.me
description : https://github.com/sbaldzenka/dds_waveform_generator

---------------------------------------------------------------------------------------
*/

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