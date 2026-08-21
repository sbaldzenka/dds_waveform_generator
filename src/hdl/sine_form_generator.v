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

module sine_form_generator
#(
    parameter F_CODE_WIDTH    = 32,
    parameter DAC_WIDTH       = 8,
    parameter BRAM_ADDR_WIDTH = 6,
    parameter SINE_TABLE_FILE = "../tables/sin_table_64.mem"
)
(
    // global signals
    input  wire                    i_system_clk,
    input  wire                    i_system_reset,
    // control signals
    input  wire                    i_gen_enable,
    input  wire [F_CODE_WIDTH-1:0] i_freq_code,
    // result signals
    output wire [   DAC_WIDTH-1:0] o_sine_dds
);

    // signals
    wire [BRAM_ADDR_WIDTH-1:0] bram_address;
    wire                       zero_crossing;
    wire [      DAC_WIDTH-1:0] sine_dds;

    address_manager
    #(
        .F_CODE_WIDTH    ( F_CODE_WIDTH    ),
        .BRAM_ADDR_WIDTH ( BRAM_ADDR_WIDTH )
    )
    address_manager_inst
    (
        .i_system_clk    ( i_system_clk   ),
        .i_system_reset  ( i_system_reset ),
        .i_freq_code     ( i_freq_code    ),
        .i_gen_enable    ( i_gen_enable   ),
        .o_zero_crossing ( zero_crossing  ),
        .o_bram_address  ( bram_address   )
    );

    sp_bram
    #(
        .ADDR_WIDTH ( BRAM_ADDR_WIDTH ),
        .DATA_WIDTH ( DAC_WIDTH       ),
        .MEM_FILE   ( SINE_TABLE_FILE )
    )
    sp_bram_inst
    (
        .i_clk  ( i_system_clk ),
        .i_addr ( bram_address ),
        .i_we   ( 1'b0         ),
        .i_data ( 8'h00        ),
        .o_data ( sine_dds     )
    );

    sine_period_offset
    #(
        .DAC_WIDTH ( DAC_WIDTH )
    )
    sine_period_offset_inst
    (
        .i_system_clk    ( i_system_clk   ),
        .i_system_reset  ( i_system_reset ),
        .i_zero_crossing ( zero_crossing  ),
        .i_dds_data      ( sine_dds       ),
        .o_dds_data      ( o_sine_dds     )
    );

endmodule