library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity datapath is
    port( clk, reset : in  std_logic;
          dp_display : out std_logic_vector (6 downto 0);
		  dp_display_enable : out std_logic_vector(3 downto 0);
		  leds_output: out std_logic_vector(7 downto 0);
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
	 
	component seq_generator
    port (
        clk      : in std_logic; 
        rst      : in std_logic;
        load     : in std_logic;
        shift_invert : in std_logic;
        seq_in   : in  std_logic_vector(7 downto 0);
        seq_out  : out std_logic_vector(7 downto 0)
    );
    end component;
    
    
    --4 bit number to 7-bit 7-segment anode vector
	component conv_7seg
        Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
               display : out  STD_LOGIC_VECTOR (6 downto 0));
    end component conv_7seg;
    
    
     --Driver for Basys3 7-segment displays
    component displays
         Port ( rst : in STD_LOGIC;
                clk : in STD_LOGIC; 
                velocidad : in  STD_LOGIC_VECTOR (1 downto 0);      
                display : out  STD_LOGIC_VECTOR (6 downto 0);
                display_enable : out  STD_LOGIC_VECTOR (3 downto 0) );
    end component displays;
	 
    -- INTERMEDIATE SIGNALS --
	signal clk_1, clk_cnt_1, clk_cnt_2 :std_logic; 
	
	signal count_secs, count1, count2 : std_logic_vector(3 downto 0);
	
	signal rst : std_logic;
	
	signal seq_gen_value: std_logic_vector(7 downto 0);
	signal d:			  std_logic_vector(6 downto 0);
	signal val1,val2    : std_logic_vector(6 downto 0);
	
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
		
	--Sequence Generator
	 SEQGEN : seq_generator port map(clk_1,reset,control(load_seq_gen), control(shift_in_gen), seq_gen_value, leds_output);
		
	--multiplexed values to dp_display
	 NUMCON1: conv_7seg port map(count1,val1);
	 NUMCON2: conv_7seg port map(count2,val2);
		
	 DISPDRIVER: displays port map(reset, clk, "10", d, dp_display_enable);
		
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
			if(count1=count2)then 
				status(equals)<='1';
			else
				status(equals)<='0';
			end if;
			
	end process;
	
	process(control)
		begin
			-- Comparator
			if(control(gen_sequence)='0')then
				seq_gen_value <= (others => '0');
			else
				seq_gen_value <= "10101010";
			end if;
			
	end process;
	
	-- Mostramos solo un digito a la vez
    process(d)
    begin
        if (d = "1111111") then
            dp_display <= val1;
        else
            dp_display <= val2;
        end if;
    end process;

end arch_dp;
