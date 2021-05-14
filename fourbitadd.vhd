library ieee;
use ieee.std_logic_1164.all;

entity fourbitadd is 
	port (a,b: in std_logic_vector(3 downto 0);
			cin: in std_logic;
			sum: out std_logic_vector (3 downto 0);
			cout: out std_logic); 
end fourbitadd; 

architecture fourbitadd_behavior of fourbitadd is
	signal c: std_logic_vector (4 downto 0);
	component fulladder 
		port (a,b,c: in std_logic;
			sum, cout: out std_logic);
	end component; 
	
	begin 
	FA0: fulladder port map (a(0), b(0), cin, sum(0), c(1));
	FA1: fulladder port map (a(1), b(1), c(1), sum(1), c(2));
	FA2: fulladder port map (a(2), b(2), c(2), sum(2), c(3));
	FA3: fulladder port map (a(3), b(3), c(3), sum(3), c(4));
	cout <= c(4);
end fourbitadd_behavior;