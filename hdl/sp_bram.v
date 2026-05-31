// project     : sp_bram
// version     : 1.1
// date        : 22.04.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/sp_bram/sp_bram_verilog

`timescale 1ns/100ps

module sp_bram
#(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 8,
    parameter MEM_FILE   = "../tables/sin_table_64.mem"
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