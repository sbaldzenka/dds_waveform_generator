// project     : dds_waveform_generator
// version     : 1.0
// data        : 04.06.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/dds_waveform_generator

`timescale 1ns/100ps

module dds
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
    input  wire [             5:0] i_signal_selector,
    input  wire [F_CODE_WIDTH-1:0] i_freq_code,
    output wire [   DAC_WIDTH-1:0] o_noise_dds,
    output wire [   DAC_WIDTH-1:0] o_square_dds,
    output wire [   DAC_WIDTH-1:0] o_saw_dds,
    output wire [   DAC_WIDTH-1:0] o_triangle_dds,
    output wire [   DAC_WIDTH-1:0] o_sine_dds
);

    // signals
    wire                 square_generator_en;
    wire                 saw_generator_en;
    wire                 saw_reverse;
    wire                 triangle_generator_en;
    wire                 sine_generator_en;
    wire                 noise_generator_en;

    // logic
    assign square_generator_en   = i_signal_selector[0];
    assign triangle_generator_en = i_signal_selector[1];
    assign saw_generator_en      = i_signal_selector[2] | i_signal_selector[3];
    assign saw_reverse           = i_signal_selector[3];
    assign noise_generator_en    = i_signal_selector[4];
    assign sine_generator_en     = i_signal_selector[5];

    square_form_generator
    #(
        .F_CODE_WIDTH ( F_CODE_WIDTH ),
        .DAC_WIDTH    ( DAC_WIDTH    )
    )
    square_form_generator_inst
    (
        .i_system_clk   ( i_system_clk        ),
        .i_system_reset ( i_system_reset      ),
        .i_gen_enable   ( square_generator_en ),
        .i_freq_code    ( i_freq_code         ),
        .o_square_dds   ( o_square_dds        )
    );

    triangle_form_generator
    #(
        .F_CODE_WIDTH ( F_CODE_WIDTH ),
        .DAC_WIDTH    ( DAC_WIDTH    )
    )
    triangle_form_generator_inst
    (
        .i_system_clk   ( i_system_clk          ),
        .i_system_reset ( i_system_reset        ),
        .i_gen_enable   ( triangle_generator_en ),
        .i_freq_code    ( i_freq_code           ),
        .o_triangle_dds ( o_triangle_dds        )
    );

    saw_form_generator
    #(
        .F_CODE_WIDTH ( F_CODE_WIDTH ),
        .DAC_WIDTH    ( DAC_WIDTH    )
    )
    saw_form_generator_inst
    (
        .i_system_clk   ( i_system_clk     ),
        .i_system_reset ( i_system_reset   ),
        .i_saw_reverse  ( saw_reverse      ),
        .i_gen_enable   ( saw_generator_en ),
        .i_freq_code    ( i_freq_code      ),
        .o_saw_dds      ( o_saw_dds        )
    );

    noise_generator
    #(
        .DAC_WIDTH ( DAC_WIDTH )
    )
    noise_generator_inst
    (
        .i_system_clk   ( i_system_clk       ),
        .i_system_reset ( i_system_reset     ),
        .i_gen_enable   ( noise_generator_en ),
        .o_noise_dds    ( o_noise_dds        )
    );

    sine_form_generator
    #(
        .F_CODE_WIDTH    ( F_CODE_WIDTH    ),
        .DAC_WIDTH       ( DAC_WIDTH       ),
        .BRAM_ADDR_WIDTH ( BRAM_ADDR_WIDTH ),
        .SINE_TABLE_FILE ( SINE_TABLE_FILE )
    )
    sine_form_generator_inst
    (
        .i_system_clk   ( i_system_clk       ),
        .i_system_reset ( i_system_reset     ),
        .i_gen_enable   ( sine_generator_en  ),
        .i_freq_code    ( i_freq_code        ),
        .o_sine_dds     ( o_sine_dds         )
    );

endmodule