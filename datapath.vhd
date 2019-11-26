library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity datapath is
    port( clk, reset : in  std_logic;
          control    : in  std_logic_vector (W_CONTROL-1 downto 0);
          status     : out std_logic_vector (W_STATUS-1  downto 0)
		   );
end datapath;

architecture arch_dp of datapath is

	 -- COMPONENTS AND MODULES --
    component clock_divider
		 port( 
			  rst      : in  std_logic;
			  clk_in   : in  std_logic; 
			  clk_1hz  : out std_logic;
			  clk_cnt1 : out std_logic;
			  clk_cnt2 : out std_logic          
		 );
	 end component;

	 component counter
		 generic (n: natural := 4;
			  modulo: natural := 15);
		 port( clk, reset, count_enable : in  std_logic;
				 count : out std_logic_vector(n-1 downto 0));
	 end component;
	 
    -- INTERMEDIATE SIGNALS --
	signal clk_1, clk_cnt_1, clk_cnt_2 :std_logic; 
	
	signal count_secs, count1, count2 : std_logic_vector(3 downto 0);
	
	signal rst : std_logic;
	
begin

	rst <= reset OR control(reset_i);
	
    -- MODULES AND INTERCONNECTIONS --
	 CLK_DIV: clock_divider port map(reset,clk, clk_1,clk_cnt_1,clk_cnt_2);
	 
	 --10 seconds counter
	 CNTR_S : counter generic map(n => 4, modulo => 10)
	 port map(clk_1,reset,control(counter_s_ce), count_secs);

	 --Roulete 1 counter
	 CNTR_1 : counter port map(clk_cnt_1,reset,control(counter_1_ce), count1);

	 --Roulete 2 counter
	 CNTR_2 : counter port map(clk_cnt_2,reset,control(counter_2_ce), count2);
		
	 process(count_secs)
		begin
			-- Comparator
			if(count_secs="1010")then --10  IF IT DOESN'T WORK CHECK THIS
				status(elapsed)<='1';
			else
				status(elapsed)<='0';
			end if;
			
	end process;
	
	process(count1,count2)
		begin
			-- Comparator
			if(count1=count2)then --10  IF IT DOESN'T WORK CHECK THIS
				status(equals)<='1';
			else
				status(equals)<='0';
			end if;
			
	end process;
	

end arch_dp;
