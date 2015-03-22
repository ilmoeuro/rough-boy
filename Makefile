ANALYZE_FLAGS=-g
ELABORATE_FLAGS=
RUN_FLAGS=--assert-level=warning 

VHDL=$(shell find *.vhdl)
TEST_VHDL=$(shell find *_test.vhdl)
OBJ=$(VHDL:.vhdl=.o)
TEST_VCD=$(TEST_VHDL:.vhdl=.vcd)

all: $(OBJ)

test: $(TEST_VCD)

clean:
	make -C doc clean
	rm -f *.o *.vcd *.cf *.out

doc:
	make -C doc all

play: synthesizer_sim_test.raw
	play -t raw -e unsigned-integer -b 8 -r 65536 -v 0.5 $<

%.raw: %.out
	LANG=C awk -v ORS="" -v BINMODE=2 '{ printf "%c", $$1; }' <$< >$@

%.o: %.vhdl
	ghdl -a $(ANALYZE_FLAGS) $<

%.vcd: %.o
	ghdl $(ELABORATE_FLAGS) -e $(subst .o,,$^)
	ghdl -r $(subst .o,,$^) --vcd="$(subst .o,.vcd,$^)" $(RUN_FLAGS) 
	rm $(subst .o,,$^)

phase_gen.o: common.o

env_gen.o: common.o

waveshaper.o: common.o

lookup.o: common.o

phase_distort.o: common.o lookup.o

delta_sigma_dac.o: common.o

amplifier.o: common.o lookup.o

delay.o: common.o
	
voice_controller.o: common.o

phase_gen_test.o: common.o phase_gen.o

env_gen_test.o: common.o env_gen.o

waveshaper_test.o: common.o waveshaper.o

phase_distort_test.o: common.o phase_distort.o

amplifier_test.o: common.o amplifier.o

delta_sigma_dac_test.o: common.o waveshaper.o delta_sigma_dac.o

waveform_test.o: common.o waveshaper.o phase_distort.o

circular_buffer.o: common.o

circular_buffer_test.o: common.o circular_buffer.o

synthesizer.o: common.o env_gen.o delta_sigma_dac.o phase_distort.o phase_gen.o waveshaper.o delay.o amplifier.o

synthesizer_test.o: common.o synthesizer.o

synthesizer_sim.o: common.o env_gen.o delta_sigma_dac.o phase_distort.o phase_gen.o waveshaper.o amplifier.o delay.o voice_controller.o

synthesizer_sim_test.o: common.o synthesizer_sim.o

synthesizer_sim_test.out: synthesizer_sim_test.vcd

.PHONY: all test clean doc play
