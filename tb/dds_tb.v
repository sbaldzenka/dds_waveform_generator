// project : dds
// version : v1.0
// data    : 26.10.2024
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

`timescale 1ns/100ps

module dds_tb
#(
    // simulation parameters
    parameter PERIOD_CLK      = 16.666, // 60 MHz
    // dds parameters
    parameter DAC_WIDTH       = 8,
    parameter BRAM_ADDR_WIDTH = 6
);

    // signals
    reg                  system_clk;
    reg                  system_reset;

    reg  [          5:0] signal_selector;

    wire [DAC_WIDTH-1:0] dds;

    initial begin
        #0   system_clk   = 1'b0;
             system_reset = 1'b1;
        #200 system_reset = 1'b0;
    end

    initial begin
        #0   signal_selector = 8'h00;

        #300 signal_selector = 6'b000001;
    end

    always #(PERIOD_CLK / 2) system_clk = ~system_clk;

    dds DUT_inst
    (
        .i_system_clk   ( system_clk    ),
        .i_system_reset ( system_reset  ),
        .i_signal_selector    ( signal_selector ),
        //.i_freq_code    ( 32'h00000047  ), // 1 Hz
        //.i_freq_code    ( 32'h000002CB  ), // 10 Hz
        //.i_freq_code    ( 32'h00001BF6  ), // 100 Hz
        //.i_freq_code    ( 32'h0001179E  ), // 1000 Hz
        //.i_freq_code    ( 32'h000AEC33  ), // 10_000 Hz
        //.i_freq_code    ( 32'h006D3A06  ), // 100_000 Hz
        //.i_freq_code    ( 32'h04444444  ), // 1000_000 Hz
        //.i_freq_code    ( 32'h2AAAAAAA  ), // 10_000_000 Hz
        //.i_freq_code    ( 32'h55555555  ), // 20_000_000 Hz
        .i_freq_code    ( 32'h80000000  ), // 30_000_000 Hz
        .o_dds          ( dds           )
    );

endmodule