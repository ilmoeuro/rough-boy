--
--    Knobs Galore - a free phase distortion synthesizer
--    Copyright (C) 2015 Ilmo Euro
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.common.all;

entity synthesizer_sim is
    port (CLK:              in  std_logic
         ;KEYS:             in  std_logic_vector(12 downto 0)
         ;PARAM:            in  synthesis_params
         ;AUDIO:            out ctl_signal
         )
    ;
end entity;

architecture synthesizer_sim_impl of synthesizer_sim is
    function keys_to_freq(keys : std_logic_vector(12 downto 0))
    return time_signal is
    begin
        case keys is
            when "0000000000001" => return to_unsigned(262, time_bits);
            when "0000000000010" => return to_unsigned(278, time_bits);
            when "0000000000100" => return to_unsigned(294, time_bits);
            when "0000000001000" => return to_unsigned(312, time_bits);
            when "0000000010000" => return to_unsigned(330, time_bits);
            when "0000000100000" => return to_unsigned(350, time_bits);
            when "0000001000000" => return to_unsigned(371, time_bits);
            when "0000010000000" => return to_unsigned(392, time_bits);
            when "0000100000000" => return to_unsigned(415, time_bits);
            when "0001000000000" => return to_unsigned(440, time_bits);
            when "0010000000000" => return to_unsigned(466, time_bits);
            when "0100000000000" => return to_unsigned(494, time_bits);
            when "1000000000000" => return to_unsigned(524, time_bits);
            when others     => return to_unsigned(0, time_bits);
        end case;
    end function;

    signal freq: time_signal := (others => '0');
    signal gate: std_logic;
    signal gain: ctl_signal;
    signal env_cutoff: time_signal;
    signal env_gain: time_signal;
    signal stage_cutoff: adsr_stage;
    signal stage_gain: adsr_stage;
    signal prev_gate_cutoff: std_logic;
    signal prev_gate_gain: std_logic;
    signal wave_sel: std_logic;
    signal theta : time_signal;

    signal cutoff_max: ctl_signal;

    signal voice_wf: waveform_t;
    signal voice_cutoff: ctl_signal;
    signal voice_theta: ctl_signal;
    signal voice_gain: ctl_signal;

    signal pd_theta: ctl_signal;
    signal pd_gain: ctl_signal;

    signal waveshaper_gain: ctl_signal;

    signal z: ctl_signal;
    signal z_ampl: ctl_signal;
begin

    gate <= '1' when KEYS /= "00000000" else '0';
    cutoff_max <= PARAM.sp_cutoff_base + PARAM.sp_cutoff_env;

    process (CLK)
    begin
        if rising_edge(CLK) then
            if gate = '1' then
                freq <= keys_to_freq(KEYS);
            end if;
        end if;
    end process;


    phase_gen:
        entity
            work.phase_gen (phase_gen_impl)
        port map
            ('1'
            ,CLK
            ,theta
            ,theta
            );

    env_gen_cutoff:
        entity
            work.env_gen (env_gen_impl)
        port map
            ('1'
            ,CLK
            ,gate
            ,PARAM.sp_cutoff_base
            ,cutoff_max
            ,PARAM.sp_cutoff_attack
            ,PARAM.sp_cutoff_decay
            ,PARAM.sp_cutoff_sustain
            ,PARAM.sp_cutoff_rel
            ,env_cutoff
            ,env_cutoff
            ,stage_cutoff
            ,stage_cutoff
            ,prev_gate_cutoff
            ,prev_gate_cutoff
            );

    env_gen_ampl:
        entity
            work.env_gen (env_gen_impl)
        port map
            ('1'
            ,CLK
            ,gate
            ,x"00"
            ,x"FF"
            ,PARAM.sp_amplitude_rel
            ,PARAM.sp_amplitude_decay
            ,PARAM.sp_amplitude_sustain
            ,PARAM.sp_amplitude_rel
            ,env_gain
            ,env_gain
            ,stage_gain
            ,stage_gain
            ,prev_gate_gain
            ,prev_gate_gain
            );

    voice_controller:
        entity
            work.voice_controller (voice_controller_impl)
        port map
            ('1'
            ,CLK
            ,PARAM.sp_mode
            ,freq
            ,env_cutoff
            ,voice_cutoff
            ,env_gain
            ,voice_gain
            ,theta
            ,voice_theta
            ,voice_wf
            );


    phase_distort:
        entity 
            work.phase_distort (phase_distort_impl)
        port map
            ('1'
            ,CLK
            ,voice_wf
            ,voice_cutoff
            ,voice_theta
            ,pd_theta
            ,voice_gain
            ,pd_gain
            );

    waveshaper:
        entity
            work.waveshaper(waveshaper_sin)
        port map
            ('1'
            ,CLK
            ,pd_theta
            ,z
            ,pd_gain
            ,waveshaper_gain
            );

    amplifier:
        entity
            work.amplifier (amplifier_impl)
        port map
            ('1'
            ,CLK
            ,waveshaper_gain
            ,z
            ,z_ampl
            );

    AUDIO <= z_ampl;
end architecture;
