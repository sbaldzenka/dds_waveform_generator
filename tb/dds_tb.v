// project : dds
// version : v1.0
// data    : 26.10.2024
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

`timescale 1ns/100ps

module dds_tb
#(
    // simulation parameters
    parameter PERIOD_CLK      = 10.000, // 50 MHz
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

        #300 signal_selector = 6'b000100;
    end

    always #PERIOD_CLK system_clk = ~system_clk;

    dds DUT_inst
    (
        .i_system_clk   ( system_clk    ),
        .i_system_reset ( system_reset  ),
        .i_signal_selector    ( signal_selector ),
        //.i_freq_code    ( 32'h00000001  ), // 1 Hz
        //.i_freq_code    ( 32'h000000FF  ), // 255 Hz
        //.i_freq_code    ( 32'h00000100  ), // 256 Hz
        //.i_freq_code    ( 32'h0002FAF0  ), // 195312 Hz
        //.i_freq_code    ( 32'h0002FAF1  ), // 195313 Hz
        //.i_freq_code    ( 32'h0007A120  ), // 500000 Hz
        //.i_freq_code    ( 32'h000F4240  ), // 1000000 Hz
        //.i_freq_code    ( 32'h004C4B40  ), // 5000000 Hz
        .i_freq_code    ( 32'h00989680  ), // 10000000 Hz
        .o_dds          ( dds           )
    );

endmodule