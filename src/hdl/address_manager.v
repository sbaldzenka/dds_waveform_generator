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

module address_manager
#(
    // dds parameters
    parameter F_CODE_WIDTH    = 32,
    parameter BRAM_ADDR_WIDTH = 8
)
(
    // global signals
    input  wire                       i_system_clk,
    input  wire                       i_system_reset,
    // control
    input  wire [   F_CODE_WIDTH-1:0] i_freq_code,
    input  wire                       i_gen_enable,
    output reg                        o_zero_crossing,
    output reg  [BRAM_ADDR_WIDTH-1:0] o_bram_address
);

    // signals
    reg [   F_CODE_WIDTH-1:0] phase_accum;
    reg                       half_period_flag;
    reg                       quarter_period_flag;
    reg [BRAM_ADDR_WIDTH-1:0] bram_address;

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
        o_zero_crossing  <= half_period_flag;
    end

    always @(posedge i_system_clk) begin
        quarter_period_flag <= phase_accum[F_CODE_WIDTH-2];
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            bram_address <= {BRAM_ADDR_WIDTH{1'b0}};
        end else begin
            bram_address <= phase_accum[F_CODE_WIDTH-1:F_CODE_WIDTH-BRAM_ADDR_WIDTH];
        end
    end

    always @(posedge i_system_clk) begin
        if (!quarter_period_flag) begin
            o_bram_address <= {bram_address[BRAM_ADDR_WIDTH-2:0], 2'b00};
        end else begin
            o_bram_address <= {BRAM_ADDR_WIDTH{1'b1}} - {bram_address[BRAM_ADDR_WIDTH-2:0], 2'b00};
        end
    end

endmodule