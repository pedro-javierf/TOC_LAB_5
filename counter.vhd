library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity counter is
	 generic (n: natural := 4;
		  modulo: natural := 15);
    port( clk, reset, count_enable : in  std_logic;
          count            		  : out std_logic_vector(n-1 downto 0));
end counter;

architecture RTL of counter is

signal reg: std_logic_vector(n-1 downto 0);

begin

	count <= reg;
	
	process(clk,reset)
	  begin
	  
		 if(reset='1') then
			reg <= (others => '0');
			
		 elsif(rising_edge(clk)) then
		 
			if(count_enable='1')then
				if(to_integer(unsigned(reg)) < modulo) then
					reg <= std_logic_vector( unsigned(reg) + 1 );
				else
					reg <= (others => '0');
				end if;
			end if;
		
		 end if;
		 
	end process;

end architecture;