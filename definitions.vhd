library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package definitions is
    -- Creates clk_out clock with a period T_out=T_in*(half_count+1)*2 
    -- for half_count greater than 0. T_in=1/100MHz=10ns
    constant FREQ_1HZ   : unsigned := "10111110101111000001111111"; -- 1Hz   => 49999999
    constant FREQ_C1    : unsigned := "1100001101001111";           -- 1KHz  =>    49999
    constant FREQ_C2    : unsigned := "1001110000111";              -- 10KHz =>     4999
    
    
    -- Control Constants
    -- COMPLETE...

	 constant counter_s_ce  : integer := 0;
	 constant counter_1_ce  : integer := 1;
	 constant counter_2_ce  : integer := 2;
	 constant reset_i       : integer := 3;
	 constant load_seq_gen  : integer := 4;
	 constant shift_in_gen  : integer := 5;
	 constant gen_sequence  : integer := 6;
    constant W_CONTROL      : integer := 7;   -- Control vector width

    -- Status Constants
    -- COMPLETE...

	 constant elapsed    : integer := 0;
	 constant equals     : integer := 1;
    constant W_STATUS   : integer := 2;   -- Status vector width
end package definitions;