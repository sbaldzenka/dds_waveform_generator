-- project : dds
-- version : 1.0
-- data    : 26.10.2024
-- author  : siarhei baldzenka
-- e-mail  : sbaldzenka@proton.me

vlib work
vmap work work

vlog ../tb/dds_tb.v

vlog ../hdl/dds.v
vlog ../hdl/square_form_generator.v
vlog ../hdl/triangle_form_generator.v
vlog ../hdl/saw_form_generator.v
vlog ../hdl/noize_generator.v
vlog ../hdl/sine_form_generator.v
vlog ../hdl/address_manager.v
vlog ../hdl/sp_bram.v
vlog ../hdl/sine_period_offset.v

vsim -t 1ps -voptargs=+acc=lprn -lib work dds_tb

do waves.do
view wave
run 2000 ms