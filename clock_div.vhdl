library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clock_div is 
	port (
	    clock: in std_logic;
	    clock_1hz: out std_logic
	   );
	
end clock_div; 

architecture clock_div_behavior of clock_div is

    signal q : std_logic_vector(25 downto 0);
	
	begin 
	    CONTADOR: process (clock) 
	    begin 
	        if rising_edge(clock) then
	            q <= q + 1;
	       end if;
	       clock_1hz <= q(25);
	   end process;

	   
end clock_div_behavior;