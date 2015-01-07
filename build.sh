#!/bin/sh

ghdl -a common.vhdl 2>&1
ghdl -a phase_gen.vhdl 2>&1
ghdl -a phase_gen_test.vhdl 2>&1
ghdl -e phase_gen_test 2>&1
ghdl -r phase_gen_test --vcd=phase_gen_test.vcd 2>&1
rm phase_gen_test

ghdl -a common.vhdl 2>&1
ghdl -a env_gen.vhdl 2>&1
ghdl -a env_gen_test.vhdl 2>&1
ghdl -e env_gen_test 2>&1
ghdl -r env_gen_test --vcd=env_gen_test.vcd 2>&1
rm env_gen_test

ghdl -a common.vhdl 2>&1
ghdl -a phase_distort.vhdl 2>&1
ghdl -a phase_distort_test.vhdl 2>&1
ghdl -e phase_distort_test 2>&1
ghdl -r phase_distort_test --vcd=phase_distort_test.vcd 2>&1
rm phase_distort_test

ghdl -a common.vhdl 2>&1
ghdl -a waveshaper.vhdl 2>&1
ghdl -a waveshaper_test.vhdl 2>&1
ghdl -e waveshaper_test 2>&1
ghdl -r waveshaper_test --vcd=waveshaper_test.vcd 2>&1
rm waveshaper_test

ghdl -a common.vhdl 2>&1
ghdl -a waveshaper.vhdl 2>&1
ghdl -a delta_sigma_dac.vhdl 2>&1
ghdl -a delta_sigma_dac_test.vhdl 2>&1
ghdl -e delta_sigma_dac_test 2>&1
ghdl -r delta_sigma_dac_test --vcd=delta_sigma_dac_test.vcd 2>&1
rm delta_sigma_dac_test

ghdl -a common.vhdl 2>&1
ghdl -a waveshaper.vhdl 2>&1
ghdl -a phase_distort.vhdl 2>&1
ghdl -a waveform_test.vhdl 2>&1
ghdl -e waveform_test 2>&1
ghdl -r waveform_test --vcd=waveform_test.vcd 2>&1
rm waveform_test

ghdl -a common.vhdl 2>&1
ghdl -a phase_gen.vhdl 2>&1
ghdl -a phase_distort.vhdl 2>&1
ghdl -a waveshaper.vhdl 2>&1
ghdl -a delta_sigma_dac.vhdl 2>&1
ghdl -a synthesizer.vhdl 2>&1
ghdl -a synthesizer_test.vhdl 2>&1
ghdl -e synthesizer_test 2>&1
ghdl -r synthesizer_test --vcd=synthesizer_test.vcd 2>&1
rm synthesizer_test

