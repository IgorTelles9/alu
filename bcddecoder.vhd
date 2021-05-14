library ieee;
use ieee.std_logic_1164.all;
 
entity bcddecoder is
    port ( 
        binario : in std_logic_vector(3 downto 0);
        bcd_1, bcd_0 : out std_logic_vector( 3 downto 0)
    );
end bcddecoder;
 
architecture bcddecoder_behavior of bcddecoder is

    signal bcd_1_sig, bcd_0_sig : std_logic_vector( 3 downto 0);
    signal restante : std_logic_vector(3 downto 0);
    signal trash : std_logic;
    
    component fourbitadd is 
	port (a,b: in std_logic_vector(3 downto 0);
			cin: in std_logic;
			sum: out std_logic_vector (3 downto 0);
			cout: out std_logic); 
    end component; 
 
    begin
        FBA1: fourbitadd 
            port map (
                a => binario,
                b => not("1010"),
                cin => '1',
                sum => restante,
                cout => trash
            );
            
        with binario select
        bcd_0_sig <= restante when 
                    "1010" | "1011" | "1100" | "1101" | "1110" | "1111",
                    binario when others;
        
        with binario select
        bcd_1_sig <= "0001" when 
                    "1010" | "1011" | "1100" | "1101" | "1110" | "1111",
                    "0000" when others;
                
        
        bcd_0 <= bcd_0_sig;
        bcd_1 <= bcd_1_sig;
end bcddecoder_behavior;
