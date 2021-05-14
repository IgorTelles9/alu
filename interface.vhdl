library ieee;
use ieee.std_logic_1164.all;

entity interface is 
	port (
	        HEX0: out std_logic_vector(6 downto 0);
	        HEX1: out std_logic_vector(6 downto 0);
	        HEX2: out std_logic_vector(6 downto 0);
	        HEX3: out std_logic_vector(6 downto 0);
	        HEX4: out std_logic_vector(6 downto 0);
	        HEX5: out std_logic_vector(6 downto 0);
	       
	       LEDG: out std_logic_vector(8 downto 0);
	       LEDR: out std_logic_vector(17 downto 0);
	       
	        V_BT: in std_logic_vector(3 downto 0);
	       
	        SW: in std_logic_vector(17 downto 0);
	        
	        CLOCK_50: in std_logic
			);
end interface;

architecture interface_behavior of interface is
	
	-- declaração de sinais
	type estado_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8);
	signal estado: estado_type;
	signal estado_blink: estado_type;
	
	signal A : std_logic_vector(3 downto 0);
	signal B : std_logic_vector(3 downto 0);
	
	signal A_bcd_und: std_logic_vector(3 downto 0);
	signal A_bcd_dez: std_logic_vector(3 downto 0);
	
	signal B_bcd_und: std_logic_vector(3 downto 0);
	signal B_bcd_dez: std_logic_vector(3 downto 0);
	
	signal Y_adder :  std_logic_vector( 3 downto 0);
	signal Y_sub : std_logic_vector( 3 downto 0);
	signal Y_mult : std_logic_vector( 3 downto 0);
	signal Y_inc : std_logic_vector( 3 downto 0);
	signal Y_and : std_logic_vector( 3 downto 0);
	signal Y_or : std_logic_vector( 3 downto 0);
	signal Y_not : std_logic_vector( 3 downto 0);
	signal Y_xor : std_logic_vector( 3 downto 0);
				
	signal COUT_adder : std_logic;
	signal COUT_sub : std_logic;
	signal COUT_mult : std_logic;
	signal COUT_inc : std_logic;
	
	signal Y_display: std_logic_vector(3 downto 0);
	signal COUT_led : std_logic; 
	signal Y_led: std_logic_vector(3 downto 0);
	signal estados_led: std_logic_vector(7 downto 0);
	
	signal Y_bcd_und: std_logic_vector(3 downto 0);
	signal Y_bcd_dez : std_logic_vector(3 downto 0);

	signal start : std_logic;
	signal start_temp: std_logic;
	signal reset : std_logic;

	signal clk_seconds: std_logic;
	
	-- declaração de componentes
	component ula is 
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
	end component;
	
	-- redutor clock declaração
    component clock_div is 
	port (
	    clock: in std_logic;
	    clock_1hz: out std_logic
	   );
    end component clock_div; 
    
    --  DECLARAÇÃO SETE SEGMENTOS
    component decoder7seg is
        port ( 
            N0,N1,N2,N3 : in STD_LOGIC;
            A,B,C,D,E,F,G : out STD_LOGIC);
    end component;
    
    -- DECLARAÇÃO BCD DECODER
    component bcddecoder is
        port ( 
            binario : in std_logic_vector(3 downto 0);
            bcd_1, bcd_0 : out std_logic_vector( 3 downto 0)
        );
    end component;
	

	--  -=-=-=-=- BEGIN DO ARCHITECTURE: OPERAÇÕES -=-=-=-=-=-=-
	begin 
	
	--  -=-=- convertendo o sinal dos switches pra binário -=-=-
	
	entradas : process (SW)
	begin 
	    if (start = '0') then 
    	    A <= SW(3) & SW(2) &  SW(1) &  SW(0);
    	    B <= SW(7) & SW(6) &  SW(5) &  SW(4);
    	end if;
	end process;
	
	-- chamada do decoder bcd: transforma de binario pra bcd
	BCDA: bcddecoder 
	    port map(
	        binario => A,
	        bcd_1 => A_bcd_dez,
	        bcd_0 => A_bcd_und
	    );

	BCDB: bcddecoder 
	    port map(
	        binario => B,
	        bcd_1 => B_bcd_dez,
	        bcd_0 => B_bcd_und
	    );
	    
	-- VERIFICANDO SE O BOTÃO DE START FOI APERTADO
	start_botao: process (V_BT(0), V_BT(1)) 
	begin -- o botao start funciona como um not(reset) do clock
	    if V_BT(1) = '1' and V_BT(0) = '0' then
	        start <= '1';
	    elsif V_BT(1) = '0' and V_BT(0) = '1' then 
	        start <= '0';
	    elsif (V_BT(1) = '1' and V_BT(0) = '1' and (start = '0') ) then 
	        start <= '0';
	   end if;
	end process; 

	-- chamada do redutor do clock 
	-- que tem 1 seg de frequência
	CLK1: clock_div 
	    port map (
	    -- recebe um clock de 50mhz
	    -- retorna um clock de 1seg
	        clock => CLOCK_50,
	        clock_1hz => clk_seconds
	    );
    -- -=-=-=- CHAMADA ULA 
	ULA1: ula 
		port map (
				A => A,
				B => B,
				Y_adder => Y_adder,
				Y_sub => Y_sub,
				Y_mult => Y_mult,
				Y_inc => Y_inc,
				Y_and => Y_and,
				Y_or => Y_or,
				Y_not => Y_not,
				Y_xor => Y_xor,
				COUT_adder => cout_adder,
				COUT_sub => cout_sub,
				COUT_mult => cout_mult,
				COUT_inc => cout_inc
				);
	 
	-- MÁQUINA DE ESTADOS QUE SELECIONA AS OPERAÇÕES
	        
    seletor: process (clk_seconds, start)
    begin 
        if clk_seconds'event and clk_seconds = '1' then
            if start = '0' then
                estado <= S0;
                estados_led <= "11111111";
            else
                case estado is 
                    when S0 => 
                    -- soma
                        estado <= S1;
                        Y_display <= Y_adder; 
                        COUT_led <= COUT_adder;
                        estados_led <= "00000001";
                    when S1 =>
                    -- subtração 
                        estado <= S2;
                        Y_display <= Y_sub;
                        COUT_led <= not(COUT_sub);
                        estados_led <= "00000010";
                    when S2 =>
                    -- multiplicação
                        estado <= S3;
                        Y_display <= Y_mult;
                        COUT_led <= COUT_mult;
                        estados_led <= "00000100";                        
                    when S3 =>
                    -- incremento
                        estado <= S4;
                        Y_display <= Y_inc;
                        COUT_led <= COUT_inc;
                        estados_led <= "00001000";
                    when S4 =>
                    -- and
                        estado <= S5;
                        Y_led <= Y_and;
                        estados_led <= "00010000";
                    when S5 =>
                    -- or
                        estado <= S6;
                        Y_led <= Y_or;
                        estados_led <= "00100000";
                    when S6 =>
                    -- not
                        estado <= S7;
                        Y_led <= Y_not;
                        estados_led <= "01000000";
                    when S7 =>
                    -- xor
                        estado <= S0;
                        Y_led <= Y_xor;
                        estados_led <= "10000000";
                    when others => 
                        null;
                end case;
            end if;
        end if; 
    end process;
                    
		-- CONVERSAO DE Y_DISPLAY PARA BCD 
		BCD_Y : bcddecoder 
		    port map (
		        binario => Y_display,
		        bcd_0 => Y_bcd_und,
		        bcd_1 => Y_bcd_dez
		    );
		
		-- CHAMADA DECODER 7 SEGMENTOS
	-- -=-=-=-=-= DISPLAY DE 7 SEGMENTOS ENTRADA A	
		-- unidades
		D7SA0: decoder7seg 
		    port map (
		        -- entradas bcd
		        N0 => A_bcd_und(3),
		        N1 => A_bcd_und(2),
		        N2 => A_bcd_und(1),
		        N3 => A_bcd_und(0), 
		        -- saida dos leds
                A => HEX0(0),
                B => HEX0(1),
                C => HEX0(2),
                D => HEX0(3),
                E => HEX0(4),
                F => HEX0(5),
                G => HEX0(6)
		    );
		    
		-- dezenas
		D7SA1: decoder7seg 
		    port map (
		        -- entradas bcd 
		        N0 => A_bcd_dez(3),
		        N1 => A_bcd_dez(2),
		        N2 => A_bcd_dez(1),
		        N3 => A_bcd_dez(0),
		        -- saidas dos leds
                A => HEX1(0),
                B => HEX1(1),
                C => HEX1(2),
                D => HEX1(3),
                E => HEX1(4),
                F => HEX1(5),
                G => HEX1(6)
		    );
		   
		-- -=-=-=-=-= DISPLAY DE 7 SEGMENTOS ENTRADA B 
        D7SB0: decoder7seg 
		    port map (
		        -- entradas bcd
		        N0 => B_bcd_und(3),
		        N1 => B_bcd_und(2),
		        N2 => B_bcd_und(1),
		        N3 => B_bcd_und(0), 
		        -- saida dos leds
                A => HEX2(0),
                B => HEX2(1),
                C => HEX2(2),
                D => HEX2(3),
                E => HEX2(4),
                F => HEX2(5),
                G => HEX2(6)
		    );
		    
		-- dezenas
		D7SB1: decoder7seg 
		    port map (
		        -- entradas bcd 
		        N0 => B_bcd_dez(3),
		        N1 => B_bcd_dez(2),
		        N2 => B_bcd_dez(1),
		        N3 => B_bcd_dez(0),
		        -- saidas dos leds
                A => HEX3(0),
                B => HEX3(1),
                C => HEX3(2),
                D => HEX3(3),
                E => HEX3(4),
                F => HEX3(5),
                G => HEX3(6)
		    );
        
    -- -=-=-=-=-= DISPLAY DE 7 SEGMENTOS SAÍDA 	
        D7SY0: decoder7seg 
		    port map (
		        -- entradas bcd
		        N0 => Y_bcd_und(3),
		        N1 => Y_bcd_und(2),
		        N2 => Y_bcd_und(1),
		        N3 => Y_bcd_und(0), 
		        -- saida dos leds
                A => HEX4(0),
                B => HEX4(1),
                C => HEX4(2),
                D => HEX4(3),
                E => HEX4(4),
                F => HEX4(5),
                G => HEX4(6)
		    );
		-- dezenas
		D7SY1: decoder7seg 
		    port map (
		        -- entradas bcd 
		        N0 => Y_bcd_dez(3),
		        N1 => Y_bcd_dez(2),
		        N2 => Y_bcd_dez(1),
		        N3 => Y_bcd_dez(0),
		        -- saidas dos leds
                A => HEX5(0),
                B => HEX5(1),
                C => HEX5(2),
                D => HEX5(3),
                E => HEX5(4),
                F => HEX5(5),
                G => HEX5(6)
		    );
		-- LEDS LÓGICOS 
		
		LEDG(0) <= Y_led(0);
		LEDG(1) <= Y_led(1);
		LEDG(2) <= Y_led(2);
		LEDG(3) <= Y_led(3); 
		
		--LED COUT
		LEDR(14) <= COUT_led;
		
		--LED ESTADOS 
		LEDR(3) <= estados_led(0);
		LEDR(4) <= estados_led(1);
		LEDR(5) <= estados_led(2);
		LEDR(6) <= estados_led(3);
		LEDR(7) <= estados_led(4);
		LEDR(8) <= estados_led(5);
		LEDR(9) <= estados_led(6);
		LEDR(10) <= estados_led(7);
end interface_behavior;


