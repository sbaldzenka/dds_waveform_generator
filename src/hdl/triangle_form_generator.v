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