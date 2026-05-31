// project : dds
// version : v1.0
// data    : 27.10.2024
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

`timescale 1ns/100ps

module dds
#(
    // dds parameters
    //parameter REF_CLOCK_HZ    = 32'h03938700, // 60_000_000 Hz
    parameter REF_CLOCK_HZ    = 32'h02FAF080, // 50_000_000 Hz
    parameter F_CODE_WIDTH    = 32,
    parameter DAC_WIDTH       = 8,
    parameter BRAM_ADDR_WIDTH = 6
)
(
    // global signals
    input  wire                    i_system_clk,
    input  wire                    i_system_reset,
    // control
    input  wire [             5:0] i_signal_selector,
    input  wire [F_CODE_WIDTH-1:0] i_freq_code,
    output wire [   DAC_WIDTH-1:0] o_dds
);

    // signals

    wire                 square_generator_en;
    wire [DAC_WIDTH-1:0] square_dds;

    wire                 saw_generator_en;
    wire                 saw_reverse;
    wire [DAC_WIDTH-1:0] saw_dds;

    wire                 triangle_generator_en;
    wire [DAC_WIDTH-1:0] triangle_dds;

    wire                 sine_generator_en;
    wire [DAC_WIDTH-1:0] sine_dds;

    // logic

    assign square_generator_en   = i_signal_selector[0];
    assign triangle_generator_en = i_signal_selector[1];
    assign saw_generator_en      = i_signal_selector[2] | i_signal_selector[3];
    assign saw_reverse           = i_signal_selector[3];
    assign noize_generator_en    = i_signal_selector[4];
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
        .o_square_dds   ( square_dds          )
    );

    triangle_form_generator
    #(
        .REF_CLOCK_HZ ( REF_CLOCK_HZ ),
        .DAC_WIDTH    ( DAC_WIDTH    )
    )
    triangle_form_generator_inst
    (
        .i_system_clk   ( i_system_clk          ),
        .i_system_reset ( i_system_reset        ),
        .i_gen_enable   ( triangle_generator_en ),
        .i_freq_code    ( i_freq_code           ),
        .o_triangle_dds ( triangle_dds          )
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
        .o_saw_dds      ( saw_dds          )
    );

    noize_generator
    #(
        .DAC_WIDTH ( DAC_WIDTH )
    )
    noize_generator_inst
    (
        .i_system_clk   ( i_system_clk       ),
        .i_system_reset ( i_system_reset     ),
        .i_gen_enable   ( noize_generator_en ),
        .o_noize_dds    ( noize_dds          )
    );

    sine_form_generator
    #(
        .REF_CLOCK_HZ ( REF_CLOCK_HZ ),
        .DAC_WIDTH    ( DAC_WIDTH    )
    )
    sine_form_generator_inst
    (
        .i_system_clk   ( i_system_clk       ),
        .i_system_reset ( i_system_reset     ),
        .i_gen_enable   ( sine_generator_en  ),
        .i_freq_code    ( i_freq_code        ),
        .o_sine_dds     ( sine_dds           )
    );

endmodule