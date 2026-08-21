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

project     : sp_bram_verilog
version     : 1.0
date        : 22.04.2026
author      : siarhei baldzenka
e-mail      : sbaldzenka@proton.me
description : https://github.com/sbaldzenka/sp_bram

---------------------------------------------------------------------------------------
*/

`timescale 1ns/100ps

module sp_bram
#(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 8,
    parameter MEM_FILE   = "path_to_mem_file/file.mem"
)
(
    // global signal
    input  wire                  i_clk,
    // wr/rd data
    input  wire                  i_we,
    input  wire [ADDR_WIDTH-1:0] i_addr,
    input  wire [DATA_WIDTH-1:0] i_data,
    output reg  [DATA_WIDTH-1:0] o_data
);

    // signals
    reg [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];

    initial begin
        $readmemh (MEM_FILE, mem);
    end

    // MEMORY MANAGEMENT
    always@(posedge i_clk) begin
        if (i_we) begin
            mem[i_addr] <= i_data;
        end

        o_data <= mem[i_addr];
    end

endmodule