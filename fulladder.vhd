library ieee;
use ieee.std_logic_1164.all;

entity fulladder is 
	port (a, b, c: in std_logic;
			sum, cout: out std_logic);
end fulladder;

architecture fulladder_behavior of fulladder is
begin
	sum <= (a xor b) xor c;
	cout <= (a and b) or (c and (a xor b));
end fulladder_behavior; 


