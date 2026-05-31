-- project : dds
-- version : 1.0
-- data    : 26.10.2024
-- author  : siarhei baldzenka
-- e-mail  : sbaldzenka@proton.me

add wave -noupdate -divider TESTBENCH
add wave -noupdate -format Logic -radix HEXADECIMAL -group {testbench} /dds_tb/*

add wave -noupdate -divider DUT
add wave -noupdate -format Logic -radix HEXADECIMAL -group {dds} /dds_tb/DUT_inst/*
--add wave -noupdate -format Logic -radix HEXADECIMAL -group {square_form_generator} /dds_tb/DUT_inst/square_form_generator_inst/*
--add wave -noupdate -format Logic -radix HEXADECIMAL -group {saw_form_generator} /dds_tb/DUT_inst/saw_form_generator_inst/*
--add wave -noupdate -format Logic -radix HEXADECIMAL -group {triangle_form_generator} /dds_tb/DUT_inst/triangle_form_generator_inst/*
add wave -noupdate -format Logic -radix HEXADECIMAL -group {noize_generator} /dds_tb/DUT_inst/noize_generator_inst/*
--add wave -noupdate -divider sine_form_generator
--add wave -noupdate -format Logic -radix HEXADECIMAL -group {sine_form_generator} /dds_tb/DUT_inst/sine_form_generator_inst/*
--add wave -noupdate -format Logic -radix HEXADECIMAL -group {address_manager} /dds_tb/DUT_inst/sine_form_generator_inst/address_manager_inst/*
--add wave -noupdate -format Logic -radix HEXADECIMAL -group {sp_bram} /dds_tb/DUT_inst/sine_form_generator_inst/sp_bram_inst/*
--add wave -noupdate -format Logic -radix HEXADECIMAL -group {sine_period_offset} /dds_tb/DUT_inst/sine_form_generator_inst/sine_period_offset_inst/*

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