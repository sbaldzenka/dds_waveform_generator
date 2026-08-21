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
            o_dds_data <= 'b0;
        end else begin
            if (zero_crossing_ff) begin
                o_dds_data <= i_dds_data;
            end else begin
                o_dds_data <= ~i_dds_data;
            end
        end
    end

endmodule