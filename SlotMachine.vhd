library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

-- SLOT MACHINE MOTHERFUCKER!!

entity SlotMachine is
    port( 
	 --CLOCK_50 : in std_logic;
	 --KEY      : in std_logic_vector(3 downto 0);
	 --HEX0     : out std_logic_vector(6 downto 0);
	 --HEX1     : out std_logic_vector(6 downto 0);
	 
	reset, clk, start, stop : in  std_logic;
          done             : out std_logic;
          leds             : out std_logic_vector(7 downto 0);
          disp_enable      : out std_logic_vector(3 downto 0);
          display          : out std_logic_vector(6 downto 0) );
end SlotMachine;


architecture Behavioural of SlotMachine is
	
	component datapath
    port( clk, reset : in  std_logic;
		  dp_display : out std_logic_vector (6 downto 0);
		  dp_display_enable : out std_logic_vector(3 downto 0);
          leds_output: out std_logic_vector(7 downto 0);
          control    : in  std_logic_vector (W_CONTROL-1 downto 0);
          status     : out std_logic_vector (W_STATUS-1  downto 0)
		   );
	end component;
	
	component controller
    port( clk, reset : in  std_logic;
			 start,stop    	: in  std_logic;
          status           : in  std_logic_vector(W_STATUS-1  downto 0);
          control          : out std_logic_vector(W_CONTROL-1 downto 0);
          done             : out std_logic );
    end component;
	
	--Debouncer filter for the buttons
	component debouncer
        port ( rst             : in std_logic;
               clk             : in std_logic;
               x               : in std_logic;
               xDeb            : out std_logic;
               xDebFallingEdge : out std_logic;
               xDebRisingEdge  : out std_logic );
    end component debouncer;
	 
	
    
	

	 --Actual bus lines for STATUS and CONTROL signals
    signal status  : std_logic_vector(W_STATUS-1  downto 0);
    signal control : std_logic_vector(W_CONTROL-1 downto 0);
	 
	 --signal display : std_logic_vector(6 downto 0);        --mapped to HW pins
	 --signal display_enable: std_logic_vector(3 downto 0);  --mapped to HW pins
	 
	 --signal reset   : std_logic;
	 
	 signal btnStart, btnStop : std_logic;
	 
begin

	--Datapath
	DP: datapath port map(clk, reset, display, disp_enable, leds, control, status);
	
	--Controller
	CU: controller port map(clk, reset, btnStart, btnStop ,status, control, done);
	
	--Debouncers
	DB1: debouncer port map(reset, clk, start, btnStart, open, open );
	DB2: debouncer port map(reset, clk, stop,  btnStop,  open, open );
	
	--CONV: conv_7seg port map();

end Behavioural;