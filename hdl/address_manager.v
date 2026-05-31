// project : dds
// version : v1.0
// data    : 27.10.2024
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

module address_manager
#(
    // dds parameters
    parameter REF_CLOCK_HZ    = 32'h03938700, // 60 MHz
    parameter BRAM_ADDR_WIDTH = 8
)
(
    // global signals
    input  wire                       i_system_clk,
    input  wire                       i_system_reset,
    // control
    input  wire [               31:0] i_freq_code,
    input  wire                       i_gen_enable,
    output reg                        o_zero_crossing,
    output reg  [BRAM_ADDR_WIDTH-1:0] o_bram_address
);

    // local parameters
    localparam [BRAM_ADDR_WIDTH-1:0] ADDR_MAX_VALUE = {BRAM_ADDR_WIDTH{1'b1}};
    localparam [BRAM_ADDR_WIDTH-1:0] ADDR_MIN_VALUE = {BRAM_ADDR_WIDTH{1'b0}};
    localparam [                2:0] S_IDLE         = 0,
                                     S_1_PERIOD     = 1,
                                     S_2_PERIOD     = 2,
                                     S_3_PERIOD     = 3,
                                     S_4_PERIOD     = 4;
    // signals

    reg [31:0] frequency_period;
    reg [31:0] period_counter;
    reg [31:0] quarter_period;
    reg [31:0] address_step;
    reg [31:0] address_counter;
    reg [ 2:0] state;

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
            quarter_period <= {32{1'b0}};
        end else begin
            quarter_period <= {2'b00, frequency_period[31:2]};
        end
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            address_step <= {32{1'b0}};
        end else begin
            if (quarter_period >= ADDR_MAX_VALUE) begin
                address_step <= quarter_period / ADDR_MAX_VALUE;
            end else begin
                address_step <= ADDR_MAX_VALUE / quarter_period;
            end
        end
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            period_counter <= {32{1'b0}};
        end else begin
            if (state != S_IDLE) begin
                period_counter <= period_counter + 1'b1;

                if (period_counter == frequency_period - 1'b1) begin
                    period_counter <= {32{1'b0}};
                end
            end
        end
    end

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE:
                    if (i_gen_enable) begin
                        state <= S_1_PERIOD;
                    end

                S_1_PERIOD:
                    if (period_counter == quarter_period - 1'b1) begin
                        state <= S_2_PERIOD;
                    end

                S_2_PERIOD:
                    if (period_counter == (2 * quarter_period) - 1'b1) begin
                        state <= S_3_PERIOD;
                    end

                S_3_PERIOD:
                    if (period_counter == (3 * quarter_period) - 1'b1) begin
                        state <= S_4_PERIOD;
                    end

                S_4_PERIOD: begin
                    if (period_counter == frequency_period - 1'b1) begin
                        state <= S_1_PERIOD;
                    end

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
            address_counter <= {32{1'b0}};
        end else begin
            if (state == S_1_PERIOD || state == S_3_PERIOD) begin
                address_counter <= address_counter + address_step;
            end

            if (state == S_2_PERIOD || state == S_4_PERIOD) begin
                address_counter <= address_counter - address_step;
            end
        end
    end

    always @(posedge i_system_clk) begin
        if (state == S_1_PERIOD || state == S_2_PERIOD) begin
            o_zero_crossing <= 1'b1;
        end else begin
            o_zero_crossing <= 1'b0;
        end
    end

    always @(posedge i_system_clk) begin
        o_bram_address <= address_counter[BRAM_ADDR_WIDTH-1:0];
    end

endmodule