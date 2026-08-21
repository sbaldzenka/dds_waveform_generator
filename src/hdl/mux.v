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

module mux
#(
    parameter DAC_WIDTH = 10
)
(
    // global signals
    input  wire                 i_system_clk,
    input  wire                 i_system_reset,
    // control
    input  wire [          5:0] i_selector,
    // input signals
    input  wire [DAC_WIDTH-1:0] i_signal_1,
    input  wire [DAC_WIDTH-1:0] i_signal_2,
    input  wire [DAC_WIDTH-1:0] i_signal_3,
    input  wire [DAC_WIDTH-1:0] i_signal_4,
    input  wire [DAC_WIDTH-1:0] i_signal_5,
    input  wire [DAC_WIDTH-1:0] i_signal_6,
    // output signal
    output reg  [DAC_WIDTH-1:0] o_signal
);

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            o_signal <= {DAC_WIDTH{1'b0}};
        end else begin
            case (i_selector)
                6'b000000: o_signal <= {DAC_WIDTH{1'b0}};
                6'b000001: o_signal <= i_signal_1;
                6'b000010: o_signal <= i_signal_2;
                6'b000100: o_signal <= i_signal_3;
                6'b001000: o_signal <= i_signal_4;
                6'b010000: o_signal <= i_signal_5;
                6'b100000: o_signal <= i_signal_6;
                default  : o_signal <= {DAC_WIDTH{1'b0}};
            endcase
        end
    end

endmodule