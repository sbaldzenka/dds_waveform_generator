// project : dds
// version : v1.0
// data    : 30.05.2026
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

`timescale 1ns/100ps

module saw_form_generator
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
    input  wire                 i_saw_reverse,
    input  wire                 i_gen_enable,
    input  wire [         31:0] i_freq_code,
    // result signals
    output reg  [DAC_WIDTH-1:0] o_saw_dds
);

    //local parameters

    localparam [2:0] S_IDLE                 = 0,
                     S_FREQUNCY_PERIOD_CALC = 1,
                     S_STEP_CALC            = 2,
                     S_SAW_RUN              = 3;

    // signals

    reg [DAC_WIDTH-1:0] saw_dds;
    reg [         31:0] frequency_period;
    reg [         31:0] step;
    reg                 downscale_flag;
    reg [         31:0] period_counter;
    reg [         31:0] step_counter;
    reg [          2:0] state;

    // logic

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: begin
                    if (i_gen_enable) begin
                        state <= S_FREQUNCY_PERIOD_CALC;
                    end
                end

                S_FREQUNCY_PERIOD_CALC: begin
                    state <= S_STEP_CALC;
                end

                S_STEP_CALC: begin
                    state <= S_SAW_RUN;
                end

                S_SAW_RUN: begin
                    if (!i_gen_enable) begin
                        state <= S_IDLE;
                    end
                end

                default:
                    state <= S_IDLE;
            endcase
        end
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            frequency_period <= {32{1'b0}};
        end else begin
            if (state == S_FREQUNCY_PERIOD_CALC) begin
                frequency_period <= REF_CLOCK_HZ / i_freq_code;
            end
        end
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            downscale_flag <= 1'b0;
            step           <= {32{1'b0}};
        end else begin
            if (state == S_STEP_CALC) begin
                if (frequency_period > {DAC_WIDTH{1'b1}}) begin
                    downscale_flag <= 1'b0;
                    step           <= frequency_period / ({DAC_WIDTH{1'b1}} + 1'b1);
                end else begin
                    downscale_flag <= 1'b1;
                    step           <= ({DAC_WIDTH{1'b1}} + 1'b1) / frequency_period;
                end
            end
        end
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            period_counter <= {32{1'b0}};
        end else begin
            if (state == S_SAW_RUN) begin
                period_counter <= period_counter + 1'b1;

                if (period_counter == frequency_period - 1'b1) begin
                    period_counter <= {32{1'b0}};
                end
            end
        end
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            step_counter <= {32{1'b0}};
        end else begin
            if (state == S_SAW_RUN && !downscale_flag) begin
                step_counter <= step_counter + 1'b1;

                if (step_counter == step - 1'b1) begin
                    step_counter <= {32{1'b0}};
                end
            end
        end
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            saw_dds <= {DAC_WIDTH{1'b0}};
        end else begin
            if (state == S_SAW_RUN) begin
                if (period_counter == {32{1'b0}}) begin
                    saw_dds <= {DAC_WIDTH{1'b0}};
                end else if (period_counter <= frequency_period) begin
                    if (downscale_flag) begin
                            saw_dds <= saw_dds + step;
                    end else begin
                        if (step_counter == step - 1'b1) begin
                            saw_dds <= saw_dds + 1'b1;
                        end
                    end
                end
            end else begin
                saw_dds <= {DAC_WIDTH{1'b0}};
            end
        end
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            o_saw_dds <= {DAC_WIDTH{1'b0}};
        end else begin
            if (i_saw_reverse) begin
                o_saw_dds <= ~saw_dds;
            end else begin
                o_saw_dds <= saw_dds;
            end
        end
    end

endmodule