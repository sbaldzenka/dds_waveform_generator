-- project     : dds_waveform_generator
-- version     : 1.0
-- data        : 26.10.2024
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/dds_waveform_generator

add wave -noupdate -divider TESTBENCH
add wave -noupdate -format Logic -radix HEXADECIMAL -group {testbench} /dds_waveform_generator_tb/*

add wave -noupdate -divider DUT
add wave -noupdate -format Logic -radix HEXADECIMAL -group {dds_waveform_generator} /dds_waveform_generator_tb/DUT_inst/*
add wave -noupdate -format Logic -radix HEXADECIMAL -group {dds} /dds_waveform_generator_tb/DUT_inst/dds_inst/*
add wave -noupdate -format Logic -radix HEXADECIMAL -group {square_form_generator} /dds_waveform_generator_tb/DUT_inst/dds_inst/square_form_generator_inst/*
add wave -noupdate -format Logic -radix HEXADECIMAL -group {saw_form_generator} /dds_waveform_generator_tb/DUT_inst/dds_inst/saw_form_generator_inst/*
add wave -noupdate -format Logic -radix HEXADECIMAL -group {triangle_form_generator} /dds_waveform_generator_tb/DUT_inst/dds_inst/triangle_form_generator_inst/*
add wave -noupdate -format Logic -radix HEXADECIMAL -group {noise_generator} /dds_waveform_generator_tb/DUT_inst/dds_inst/noise_generator_inst/*
add wave -noupdate -divider sine_form_generator
add wave -noupdate -format Logic -radix HEXADECIMAL -group {sine_form_generator} /dds_waveform_generator_tb/DUT_inst/dds_inst/sine_form_generator_inst/*
add wave -noupdate -format Logic -radix HEXADECIMAL -group {address_manager} /dds_waveform_generator_tb/DUT_inst/dds_inst/sine_form_generator_inst/address_manager_inst/*
add wave -noupdate -format Logic -radix HEXADECIMAL -group {sp_bram} /dds_waveform_generator_tb/DUT_inst/dds_inst/sine_form_generator_inst/sp_bram_inst/*
add wave -noupdate -format Logic -radix HEXADECIMAL -group {sine_period_offset} /dds_waveform_generator_tb/DUT_inst/dds_inst/sine_form_generator_inst/sine_period_offset_inst/*
add wave -noupdate -divider mux
add wave -noupdate -format Logic -radix HEXADECIMAL -group {mux} /dds_waveform_generator_tb/DUT_inst/mux_inst/*
add wave -noupdate -divider amp_ctrl
add wave -noupdate -format Logic -radix HEXADECIMAL -group {amp_ctrl} /dds_waveform_generator_tb/DUT_inst/amp_ctrl_inst/*

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1611 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps