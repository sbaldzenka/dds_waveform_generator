-- project     : dds_waveform_generator
-- version     : 1.0
-- data        : 26.10.2024
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/dds_waveform_generator

vlib work
vmap work work

vlog ../tb/test_param.vh
vlog ../tb/dds_waveform_generator_tb.v

vlog ../hdl/dds_waveform_generator.v

vlog ../hdl/dds.v
vlog ../hdl/square_form_generator.v
vlog ../hdl/triangle_form_generator.v
vlog ../hdl/saw_form_generator.v
vlog ../hdl/noise_generator.v
vlog ../hdl/sine_form_generator.v
vlog ../hdl/address_manager.v
vlog ../hdl/sp_bram.v
vlog ../hdl/sine_period_offset.v

vlog ../hdl/mux.v
vlog ../hdl/amp_ctrl.v

vsim -t 1ps -voptargs=+acc=lprn -lib work dds_waveform_generator_tb

do waves.do
view wave
run 2000 ms