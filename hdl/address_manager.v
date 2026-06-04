// project     : dds_waveform_generator
// version     : 1.0
// data        : 04.06.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/dds_waveform_generator

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