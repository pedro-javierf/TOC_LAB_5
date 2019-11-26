library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

-- SLOT MACHINE MOTHERFUCKER!!

entity SlotMachine is
    port( 
	 CLOCK_50 : in std_logic;
	 KEY      : in std_logic_vector(3 downto 0);
	 HEX0     : out std_logic_vector(6 downto 0);
	 HEX1     : out std_logic_vector(6 downto 0);
	 
	reset, clk, start, stop : in  std_logic;
          done             : out std_logic;
          disp_enable      : out std_logic_vector(3 downto 0);
          display          : out std_logic_vector(6 downto 0) );
end SlotMachine;


architecture Behavioural of SlotMachine is
	
	component datapath
    port( clk, reset : in  std_logic;
			 dp_display : out std_logic_vector (6 downto 0);
			 dp_display_enable : out std_logic_vector(3 downto 0);
          control    : in  std_logic_vector (W_CONTROL-1 downto 0);
          status     : out std_logic_vector (W_STATUS-1  downto 0)
		   );
	end component;
	
	--comonent controller
		--port()
	--end component;
	
	--Debouncer filter for the buttons
	component debouncer
        port ( rst             : in std_logic;
               clk             : in std_logic;
               x               : in std_logic;
               xDeb            : out std_logic;
               xDebFallingEdge : out std_logic;
               xDebRisingEdge  : out std_logic );
    end component debouncer;
	 
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

	 --Actual bus lines for STATUS and CONTROL signals
    signal status  : std_logic_vector(W_STATUS-1  downto 0);
    signal control : std_logic_vector(W_CONTROL-1 downto 0);
	 
	 --signal display : std_logic_vector(6 downto 0);        --mapped to HW pins
	 --signal display_enable: std_logic_vector(3 downto 0);  --mapped to HW pins
	 
	 --signal reset   : std_logic;
	 
begin

	--reset <= KEY(0); --OR rst_i ?
	--HEX0 <= display;

	--Datapath
	DP: datapath port map(clk, reset, display, disp_enable, control, status);
	
	--Controller
	--CU: controller port map();
	

end Behavioural;