library ieee;
use ieee.std_logic_1164.all;

entity fourbitmultiplier is 
	port (
		A, B: in std_logic_vector(3 downto 0);
		Z: out std_logic_vector(3 downto 0);
		cout: out std_logic
	
	); 
end fourbitmultiplier; 

architecture fourbitmultiplier_behavior of fourbitmultiplier is

	signal s0, s1, s2, s3, s4 : std_logic; -- s são sinais intermediários
	signal y0, y1, y2, y3, y4: std_logic;	-- y são as saídas
	signal c0, c1, c2, c3, c4, c5, c6, c7: std_logic;	-- c são carries
	
	component fulladder is 
		port (a, b, c: in std_logic;
				sum, cout: out std_logic);
	end component fulladder;
	
	begin
		y0 <= A(0) and B(0);
		FA0: fulladder -- calcula y1 
			port map(
					a => A(1) and B(0),
					b => A(0) and B(1),
					c => '0',
					sum => y1,
					cout => c0
				);

		FA1: fulladder -- calcula y2 pt1
			port map(
					a => A(2) and B(0),
					b => A(1) and B(1),
					c => c0,
					sum => s0,
					cout => c1
				);		
			
		FA2: fulladder -- calcula y2 pt2
			port map(
					a => s0,
					b => A(0) and B(2),
					c => '0',
					sum => y2,
					cout => c2
				);		

		FA3: fulladder -- calcula y3 pt1
			port map(
					a => A(3) and B(0),
					b => A(2) and B(1),
					c => c1,
					sum => s1,
					cout => c3
				);	
			
		FA4: fulladder -- calcula y3 pt2
			port map(
					a => s1,
					b => A(1) and B(2),
					c => c2,
					sum => s2,
					cout => c4
				);	
				
		FA5: fulladder -- calcula y3 pt3
			port map(
					a => s2,
					b => A(0) and B(3),
					c => '0',
					sum => y3,
					cout => c5
				);	
				
		FA6: fulladder -- calcula y4 pt1
			port map(
					a => '0',
					b => A(3) and B(1),
					c => c3,
					sum => s3,
					cout => c6
				);	

		FA7: fulladder -- calcula y4 pt2
			port map(
					a => s3,
					b => A(2) and B(2),
					c => c4,
					sum => s4,
					cout => c7
				);	
				
		FA8: fulladder -- calcula y4 pt3
			port map(
					a => s4,
					b => A(1) and B(3),
					c => c5,
					sum => y4
				);	
				
				
		Z <= y3 & y2 & y1 & y0;
		cout <= y4;

end fourbitmultiplier_behavior;