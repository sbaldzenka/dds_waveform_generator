// project : dds
// version : v1.0
// data    : 30.05.2026
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

`timescale 1ns/100ps

module noize_generator
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
    // result signals
    output reg  [DAC_WIDTH-1:0] o_noize_dds
);

    // signals

    reg  [15:0] lfsr_register;
    wire        feedback;

    // logic

    assign feedback = lfsr_register[15] ^ lfsr_register[14] ^ lfsr_register[1] ^ lfsr_register[0];

    always @(posedge i_system_clk) begin
        if (i_system_reset) begin
            lfsr_register <= {16{1'b1}};
        end else begin
            lfsr_register <= {lfsr_register[14:0], feedback};
        end
    end

    always @(posedge i_system_clk) begin
        o_noize_dds <= lfsr_register[DAC_WIDTH-1:0];
    end

endmodule