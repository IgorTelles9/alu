library ieee;
use ieee.std_logic_1164.all;
 
entity decoder7seg is
    port ( 
    N0,N1,N2,N3 : in std_logic;
    A,B,C,D,E,F,G : out std_logic);
end decoder7seg;
 
architecture decoder7seg_behavior of decoder7seg is
 
begin
 
    A <= not( N0 or N2 or (N1 and N3) or (not N1 and not N3));
    B <= not( (not N1) or (not N2 and not N3) or (N2 and N3) );
    C <= not( N1 or not N2 or N3);
    D <= not( (not N1 and not N3) or (N2 and not N3) or (N1 and not N2 and N3) or (not N1 and N2) or N0);
    E <= not( (not N1 and not N3) or (N2 and not N3));
    F <= not( N0 or (not N2 and not N3) or (N1 and not N2) or (N1 and not N3));
    G <=not ( N0 or (N1 and not N2) or ( not N1 and N2) or (N2 and not N3));

end decoder7seg_behavior;
