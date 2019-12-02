library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity controller is
    port( clk, reset : in  std_logic;
			 start,stop    	: in  std_logic;
          status           : in  std_logic_vector(W_STATUS-1  downto 0);
          control          : out std_logic_vector(W_CONTROL-1 downto 0);
          done             : out std_logic );
end controller;

architecture arch_controller of controller is
    type T_STATE is (S_rst, S_wait_start, S_wait_stop, S_cmp, S_load, S_wait_tensecs);
    signal STATE, NEXT_STATE: T_STATE;
begin

	SYNC_STATE: process (clk, reset)
	begin
		if clk'event and clk = '1' then
			if reset = '1' then
				STATE <= S_rst;
			else
				STATE <= NEXT_STATE;
			end if;
		end if;
	end process SYNC_STATE;


    COMB: process (STATE, status)
    begin
        control <= (others => '0');
        done    <= '0';
        
        case STATE is
            when S_rst =>
            
                     control(reset_i) <= '1';
					 NEXT_STATE <= S_wait_start;
				
            when S_wait_start =>
				
					--rotate leds
					
					control(reset_i) <= '0';
					control(shift_in_gen) <= '1';
					
					
					if(start='1')then
						NEXT_STATE <= S_wait_stop;
					else
						NEXT_STATE <= S_wait_start;
					end if;
				
                
            when S_wait_stop =>
					
					--enable counters
					control(counter_1_ce) <= '1';
					control(counter_2_ce) <= '1';
					
					--sequence of leds
					control(load_seq_gen) <= '1'; --activate load
					control(gen_sequence) <= '0'; --load 00000000
					
					if(stop='1')then
						NEXT_STATE <= S_wait_stop;
					else
						NEXT_STATE <= S_cmp;
					end if;
				
                
            when S_cmp =>
					
					--stops roulettes
					control(counter_1_ce) <= '0';
					control(counter_2_ce) <= '0';
                
                    --CONTROLLER CV4
                    control(load_seq_gen) <= '1'; --activate load
					control(gen_sequence) <= '0'; --load 00000000
                
					if(status(equals)='1')then
						NEXT_STATE <= S_Load;
					else
						NEXT_STATE <= S_wait_tensecs;
					end if;
					 
					 
            when S_load =>
					--enable sequence generator thing, firstly inputting the "1010101" seuqnece then inverting it
				
				    control(load_seq_gen) <= '1'; --activate load
				    control(gen_sequence) <= '1'; --load 01010101
				    
				    NEXT_STATE <= S_wait_tensecs;
				
			when S_wait_tensecs =>
				
					control(counter_s_ce) <= '1';
				    control(shift_in_gen) <= '0';
				
					if(status(elapsed)='1')then
						NEXT_STATE <= S_rst;
					else
						NEXT_STATE <= S_wait_tensecs;
					end if;
				
				
                
        end case;
    end process;

end arch_controller;
