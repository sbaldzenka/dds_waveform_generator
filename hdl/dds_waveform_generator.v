// project     : dds_waveform_generator
// version     : 1.0
// data        : 04.06.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/dds_waveform_generator

`timescale 1ns/100ps

module dds_waveform_generator
#(
    parameter F_CODE_WIDTH    = 32,
    parameter DAC_WIDTH       = 10,
    parameter BRAM_ADDR_WIDTH = 8,
    parameter SINE_TABLE_FILE = "../tables/sin_table_10b_256p.mem"
)
(
    // global signals
    input  wire                    i_system_clk,
    input  wire                    i_system_reset,
    // control
    input  wire [   DAC_WIDTH-1:0] i_amp_value,
    input  wire [             5:0] i_signal_selector,
    input  wire [F_CODE_WIDTH-1:0] i_freq_code,
    output wire [   DAC_WIDTH-1:0] o_dds
);

    wire [DAC_WIDTH-1:0] noise_dds;
    wire [DAC_WIDTH-1:0] square_dds;
    wire [DAC_WIDTH-1:0] saw_dds;
    wire [DAC_WIDTH-1:0] triangle_dds;
    wire [DAC_WIDTH-1:0] sine_dds;
    wire [DAC_WIDTH-1:0] raw_dds;
    wire [DAC_WIDTH-1:0] am_dds;

    dds
    #(
        .F_CODE_WIDTH    ( F_CODE_WIDTH    ),
        .DAC_WIDTH       ( DAC_WIDTH       ),
        .BRAM_ADDR_WIDTH ( BRAM_ADDR_WIDTH ),
        .SINE_TABLE_FILE ( SINE_TABLE_FILE )
    )
    dds_inst
    (
        .i_system_clk      ( i_system_clk      ),
        .i_system_reset    ( i_system_reset    ),
        .i_signal_selector ( i_signal_selector ),
        .i_freq_code       ( i_freq_code       ),
        .o_noise_dds       ( noise_dds         ),
        .o_square_dds      ( square_dds        ),
        .o_saw_dds         ( saw_dds           ),
        .o_triangle_dds    ( triangle_dds      ),
        .o_sine_dds        ( sine_dds          )
    );

    mux
    #(
        .DAC_WIDTH ( DAC_WIDTH )
    )
    mux_inst
    (
        .i_system_clk   ( i_system_clk      ),
        .i_system_reset ( i_system_reset    ),
        .i_selector     ( i_signal_selector ),
        .i_signal_1     ( square_dds        ),
        .i_signal_2     ( triangle_dds      ),
        .i_signal_3     ( saw_dds           ),
        .i_signal_4     ( saw_dds           ),
        .i_signal_5     ( noise_dds         ),
        .i_signal_6     ( sine_dds          ),
        .o_signal       ( raw_dds           )
    );

    amp_ctrl
    #(
        .DAC_WIDTH ( DAC_WIDTH )
    )
    amp_ctrl_inst
    (
        .i_system_clk   ( i_system_clk   ),
        .i_amp_value    ( i_amp_value    ),
        .i_signal       ( raw_dds        ),
        .o_signal       ( o_dds          )
    );

endmodule