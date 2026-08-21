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