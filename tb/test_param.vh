// project     : dds_waveform_generator
// version     : 1.0
// data        : 04.06.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/dds_waveform_generator

`ifndef TEST_PARAM_VH
`define TEST_PARAM_VH


    // !UNCOMMENT THE REQUIRED PARAMETER
    //---------------------------------------------------------

    `define PERIOD_CLK      16.666 // 60 MHz
    `define F_CODE_WIDTH    32
    `define DAC_WIDTH       10
    `define BRAM_ADDR_WIDTH 8

    //`define SIN_TABLE       "../tables/sin_table_8b_64p.mem"
    `define SIN_TABLE       "../tables/sin_table_10b_256p.mem"

    // Frequency codes for Fclk = 60 MHz and F_CODE_WIDTH = 32
    // [ --> FREQ_CODE = (Fout*2^F_CODE_WIDTH)/Fclk ]
    //---------------------------------------------------------
    //`define FREQ_CODE 32'h00000047 // 1 Hz
    //`define FREQ_CODE 32'h000002CB // 10 Hz
    //`define FREQ_CODE 32'h00001BF6 // 100 Hz
    //`define FREQ_CODE 32'h0001179E // 1000 Hz
    //`define FREQ_CODE 32'h000AEC33 // 10_000 Hz
    //`define FREQ_CODE 32'h006D3A06 // 100_000 Hz
    `define FREQ_CODE 32'h04444444 // 1000_000 Hz
    //`define FREQ_CODE 32'h2AAAAAAA // 10_000_000 Hz

    // Waveforms
    //---------------------------------------------------------
    `define WAVEFORM 6'b000001 // square
    //`define WAVEFORM 6'b000010 // triangle
    //`define WAVEFORM 6'b000100 // saw
    //`define WAVEFORM 6'b001000 // saw reverse
    //`define WAVEFORM 6'b010000 // noise
    //`define WAVEFORM 6'b100000 // sine

`endif