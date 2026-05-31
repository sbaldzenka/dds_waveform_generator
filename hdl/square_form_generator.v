// project : dds
// version : v1.0
// data    : 30.05.2026
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

`timescale 1ns/100ps

module square_form_generator
#(
    // dds parameters
    parameter REF_CLOCK_HZ = 32'h03938700, // 60 MHz
    parameter DAC_WIDTH    = 8
)
(
    // global signals
    input  wire                 i_system_clk,
    input  wire                 i_system_reset,
    // control signals
    input  wire                 i_gen_enable,
    input  wire [         31:0] i_freq_code,
    // result signals
    output reg  [DAC_WIDTH-1:0] o_square_dds
);

    // signals

    reg [31:0] half_square_period;
    reg [31:0] frequency_period;
    reg [31:0] period_counter;

    // logic

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            frequency_period <= {32{1'b0}};
        end else begin
            frequency_period <= REF_CLOCK_HZ / i_freq_code;
        end
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            half_square_period <= {32{1'b0}};
        end else begin
            half_square_period <= {1'b0, frequency_period[31:1]};
        end
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            period_counter <= {32{1'b0}};
        end else begin
            if (i_gen_enable) begin
                period_counter <= period_counter + 1'b1;

                if (period_counter == frequency_period - 1'b1) begin
                    period_counter <= {32{1'b0}};
                end
            end
        end
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            o_square_dds <= {DAC_WIDTH{1'b0}};
        end else begin
            if (i_gen_enable) begin
                if (period_counter == half_square_period - 1'b1) begin
                    o_square_dds <= {DAC_WIDTH{1'b1}};
                end

                if (period_counter == frequency_period - 1'b1) begin
                    o_square_dds <= {DAC_WIDTH{1'b0}};
                end
            end else begin
                o_square_dds <= {DAC_WIDTH{1'b0}};
            end
        end
    end

endmodule