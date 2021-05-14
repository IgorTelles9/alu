library ieee;
use ieee.std_logic_1164.all;

entity ula is 
	port (
			
			A: in std_logic_vector(3 downto 0);
			B: in std_logic_vector(3 downto 0); 
			
			Y_adder : out std_logic_vector( 3 downto 0);
			Y_sub : out std_logic_vector( 3 downto 0);
			Y_mult : out std_logic_vector( 3 downto 0);
			Y_inc : out std_logic_vector( 3 downto 0);
			Y_and : out std_logic_vector( 3 downto 0);
			Y_or : out std_logic_vector( 3 downto 0);
			Y_not : out std_logic_vector( 3 downto 0);
			Y_xor : out std_logic_vector( 3 downto 0);
			
						
			COUT_adder : out std_logic;
			COUT_sub : out std_logic;
			COUT_mult : out std_logic;
			COUT_inc : out std_logic
			);
end ula;

architecture ula_behavior of ula is
	
	-- declaração de sinais
	signal cin : std_logic;
	
	
	-- declaração de componentes
	
	-- four bit adder declaração
	component fourbitadd is 
		port (a,b: in std_logic_vector(3 downto 0);
				cin: in std_logic;
				sum: out std_logic_vector (3 downto 0);
				cout: out std_logic); 
	end component fourbitadd; 
	
	-- four bit multiplier declaração
	component fourbitmultiplier is 
	port (
		A, B: in std_logic_vector(3 downto 0);
		Z: out std_logic_vector(3 downto 0);
		cout: out std_logic
		); 
	end component fourbitmultiplier;

	
	--  -=-=-=-=- BEGIN DO ARCHITECTURE: OPERAÇÕES -=-=-=-=-=-=-
	begin 
	
	    -- -=-=-=- CHAMADA ADDER E MULTIPLIER -=-=-=-=
		FBA1: fourbitadd 
			port map (
				a => A,
				b => B,
				cin => '0',
				sum => Y_adder,
				cout => COUT_adder
				);	
				
		FBA2: fourbitadd 
			port map (
				a => A,
				b => not(B),
				cin => '1',
				sum => Y_sub,
				cout => COUT_sub
				);	
				
		FBA3: fourbitadd 
			port map (
				a => A,
				b => "0000",
				cin => '1',
				sum => Y_inc,
				cout => COUT_inc
				);			
		
		FBM1: fourbitmultiplier 
			port map (
				A => A,
				B => B,
				Z => Y_mult,
				cout => COUT_mult
			);
			
		
		Y_and <= A and B;
		Y_or <= A or B;
		Y_not <= not(A);
		Y_xor <= A xor B;
	
		
	
						
end ula_behavior;


